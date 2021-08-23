// Copyright 2019 The Gaea Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package service

import (
	"fmt"
	"sync"

	"github.com/dbproxy/cc/proxy"
	"github.com/dbproxy/core"
	"github.com/dbproxy/log"
	"github.com/dbproxy/models"
)

const (
	Online  = "online"
	Offline = "offline"
)

func getCoordinatorRoot(cluster string) string {
	if cluster != "" {
		return "/" + core.EtcdRootPrefix + "/" + cluster
	}
	return "/" + core.EtcdRootPrefix
}

// ListNamespace return names of all namespace
func ListNamespace(cfg *models.CCConfig, cluster string) ([]string, error) {
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	mConn := models.NewStore(client)
	defer mConn.Close()
	return mConn.ListNamespace()
}

// ListNamespace return names of all namespace
func ListCluster(cfg *models.CCConfig, cluster string) ([]string, error) {
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	mConn := models.NewStore(client)
	defer mConn.Close()
	return mConn.ListByNameSpace(cluster)
}

// QueryNamespace return information of namespace specified by names
func QueryNamespace(names []string, cfg *models.CCConfig, cluster string) (data []*models.Namespace, err error) {
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	mConn := models.NewStore(client)
	defer mConn.Close()
	for _, v := range names {
		namespace, err := mConn.LoadNamespace(cfg.EncryptKey, v)
		if err != nil {
			log.Warn("load namespace %s failed, %v", v, err.Error())
			return nil, err
		}
		if namespace == nil {
			log.Warn("namespace %s not found", v)
			return data, nil
		}
		data = append(data, namespace)
	}

	return data, nil
}

// ModifyNamespace create or modify namespace
func ModifyNamespace(namespace *models.Namespace, cfg *models.CCConfig, cluster string) (err error) {
	if err = namespace.Verify(); err != nil {
		return fmt.Errorf("verify namespace error: %v", err)
	}

	// create/modify will save encrypted data default
	if err = namespace.Encrypt(cfg.EncryptKey); err != nil {
		return fmt.Errorf("encrypt namespace error: %v", err)
	}

	// sink namespace
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	storeConn := models.NewStore(client)
	defer storeConn.Close()

	if err := storeConn.UpdateNamespace(namespace); err != nil {
		log.Warn("update namespace failed, %s", string(namespace.Encode()))
		return err
	}

	// proxies ready to reload config
	proxies, err := storeConn.ListProxyMonitorMetrics()
	if err != nil {
		log.Warn("list proxies failed, %v", err)
		return err
	}

	// prepare phase
	for _, v := range proxies {
		err := proxy.PrepareConfig(v.IP+":"+v.AdminPort, namespace.Name, cfg)
		if err != nil {
			return err
		}
	}

	// commit phase
	for _, v := range proxies {
		err := proxy.CommitConfig(v.IP+":"+v.AdminPort, namespace.Name, cfg)
		if err != nil {
			return err
		}
	}

	return nil
}

// DelNamespace delete namespace
func DelNamespace(name string, cfg *models.CCConfig, cluster string) error {
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	mConn := models.NewStore(client)
	defer mConn.Close()

	if err := mConn.DelNamespace(name); err != nil {
		log.Warn("delete namespace %s failed, %s", name, err.Error())
		return err
	}

	proxies, err := mConn.ListProxyMonitorMetrics()
	if err != nil {
		log.Warn("list proxy failed, %s", err.Error())
		return err
	}

	for _, v := range proxies {
		err := proxy.DelNamespace(v.IP+":"+v.AdminPort, name, cfg)
		if err != nil {
			log.Warn("delete namespace %s in proxy %s failed, err: %s", name, v.IP, err.Error())
			return err
		}
	}

	return nil
}

// SQLFingerprint return sql fingerprints of all proxy
func SQLFingerprint(name string, cfg *models.CCConfig, cluster string) (slowSQLs, errSQLs map[string]string, err error) {
	slowSQLs = make(map[string]string, 16)
	errSQLs = make(map[string]string, 16)
	// list proxy
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	mConn := models.NewStore(client)
	defer mConn.Close()
	proxies, err := mConn.ListProxyMonitorMetrics()
	if err != nil {
		log.Warn("list proxy failed, %v", err)
		return nil, nil, err
	}
	wg := new(sync.WaitGroup)
	respC := make(chan *proxy.SQLFingerprint, len(proxies))
	// query sql fingerprints concurrently
	for _, p := range proxies {
		wg.Add(1)
		host := p.IP + ":" + p.AdminPort
		go func(host, name string) {
			defer wg.Done()
			r, err := proxy.QueryNamespaceSQLFingerprint(host, name, cfg)
			if err != nil {
				log.Warn("query namespace sql fingerprint failed ,%v", err)
			}
			respC <- r
		}(host, name)
	}
	wg.Wait()
	close(respC)

	for r := range respC {
		if r == nil {
			continue
		}
		for k, v := range r.SlowSQL {
			slowSQLs[k] = v
		}
		for k, v := range r.ErrorSQL {
			errSQLs[k] = v
		}
	}

	return
}

// ProxyConfigFingerprint return fingerprints of all proxy
func ProxyConfigFingerprint(cfg *models.CCConfig, cluster string) (r map[string]string, err error) {
	// list proxy
	client := models.NewClient(models.ConfigEtcd, cfg.CoordinatorAddr, cfg.UserName, cfg.Password, getCoordinatorRoot(cluster))
	mConn := models.NewStore(client)
	defer mConn.Close()
	proxies, err := mConn.ListProxyMonitorMetrics()
	if err != nil {
		log.Warn("list proxy failed, %v", err)
		return nil, err
	}
	wg := new(sync.WaitGroup)
	r = make(map[string]string, len(proxies))
	respC := make(chan map[string]string, len(proxies))
	for _, p := range proxies {
		host := p.IP + ":" + p.AdminPort
		wg.Add(1)
		go func(host string) {
			defer wg.Done()
			md5, err := proxy.QueryProxyConfigFingerprint(host, cfg)
			if err != nil {
				log.Warn("query config fingerprint of proxy failed, %s %v", host, err)
			}
			m := make(map[string]string, 1)
			m[host] = md5
			respC <- m
		}(host)
	}
	wg.Wait()
	close(respC)
	for resp := range respC {
		if resp == nil {
			continue
		}
		for k, v := range resp {
			r[k] = v
		}
	}
	return
}

/**
切换namespace机房
*/
func PromoteDc(names []string, cfg *models.CCConfig, cluster string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	for _, namespace := range namespaces {
		//如果已经是主机房则不提升成主机房
		if namespace.MasterDC == true {
			continue
		}
		for _, slice := range namespace.Slices {
			master := slice.Master
			slaves := slice.Slaves
			slice.Master = slice.SlaveDCMaster
			slice.Slaves = slice.SlaveDCSlaves
			slice.SlaveDCMaster = master
			slice.SlaveDCSlaves = slaves
		}

		namespace.MasterDCOrigin = namespace.MasterDC //先保存下来 备份下
		namespace.MasterDC = !namespace.MasterDC
		//调用modify修改namespace
		err = ModifyNamespace(namespace, cfg, cluster)
		if err != nil {
			log.Warn("modifyNamespace failed, err: %v", err)
			return err
		}
	}

	return nil
}

func ForceMasterForSingleNamespace(name string, cfg *models.CCConfig, cluster string) error {
	names := []string{name}
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("ForceMasterForSingleNamespace query namespace failed, %v", err)
		return err
	}
	for _, namespace := range namespaces {
		if namespace.MasterDC == true {
			continue
		}
		namespace.ForceMaster = true
		err = ModifyNamespace(namespace, cfg, cluster)
		if err != nil {
			log.Warn("ForceMasterForSingleNamespace modifyNamespace failed, err: %v", err)
			return err
		}
	}
	return nil
}

func CancelForceMasterForSingleNamespace(name string, cfg *models.CCConfig, cluster string) error {
	names := []string{name}
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("CancelForceMasterForSingleNamespace query namespace failed, %v", err)
		return err
	}
	for _, namespace := range namespaces {
		namespace.ForceMaster = false
		err = ModifyNamespace(namespace, cfg, cluster)
		if err != nil {
			log.Warn("CancelForceMasterForSingleNamespace modifyNamespace failed, err: %v", err)
			return err
		}
	}
	return nil
}

/**
切换namespace机房
*/
func ResumeDc(names []string, cfg *models.CCConfig, cluster string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	for _, namespace := range namespaces {
		//如果MasterDCOrigin和MasterDC相等则不用恢复
		if namespace.MasterDC == namespace.MasterDCOrigin {
			log.Warn("This namespace %s do not meet the condition", namespace.Name)
			continue
		}

		for _, slice := range namespace.Slices {
			master := slice.Master
			slaves := slice.Slaves
			slice.Master = slice.SlaveDCMaster
			slice.Slaves = slice.SlaveDCSlaves
			slice.SlaveDCMaster = master
			slice.SlaveDCSlaves = slaves
		}

		namespace.MasterDC = namespace.MasterDCOrigin
		//调用modify修改namespace
		err = ModifyNamespace(namespace, cfg, cluster)
		if err != nil {
			log.Warn("modifyNamespace failed, err: %v", err)
			return err
		}
	}

	return nil
}

/**
切换集群下的主从
*/
func SwitchMasterSlave(names []string, cfg *models.CCConfig, cluster string, oldAddr string, newAddr string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	isModify := false
	for _, namespace := range namespaces {
		for _, slice := range namespace.Slices {
			if slice.Master == oldAddr {
				slice.Master = newAddr
				isModify = true
			} else {
				slaves := make([]string, 0)
				for _, slaveNode := range slice.Slaves {
					if slaveNode == oldAddr {
						slaves = append(slaves, newAddr)
						isModify = true
					} else {
						slaves = append(slaves, slaveNode)
					}
				}

				slice.Slaves = slaves
			}
		}
		//调用modify修改namespace isModify为true时才需要修改，避免浪费
		if isModify {
			err = ModifyNamespace(namespace, cfg, cluster)

			isModify = false //清除上一次标记，恢复原位
			if err != nil {
				log.Warn("namespace:%s modifyNamespace failed, err: %v", namespace.Name, err)
				return err
			}
		}
	}

	return nil
}

func ReplaceMasterIp(names []string, cfg *models.CCConfig, cluster string, oldAddr string, newAddr string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	isModify := false
	for _, namespace := range namespaces {
		for _, slice := range namespace.Slices {
			if slice.Master == oldAddr {
				slice.Master = newAddr
				isModify = true
			}
		}
		if isModify {
			err = ModifyNamespace(namespace, cfg, cluster)
			isModify = false
			if err != nil {
				log.Warn("ReplaceMasterIp namespace:%s modifyNamespace  failed, err: %v", namespace.Name, err)
				return err
			}
			log.Notice("ReplaceMasterIp namespace:%s oldAddr:%s newAddr:%s IpmodifyNamespace success", namespace.Name, oldAddr, newAddr)
		}
	}
	return nil
}

func OnlineOrOfflineSlaveIpMasterDC(names []string, cfg *models.CCConfig, cluster, oldAddr, action string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	isModify := false
	for _, namespace := range namespaces {
		for _, slice := range namespace.Slices {
			index := -1
			for k, v := range slice.Slaves {
				if v == oldAddr {
					index = k
				}
			}
			if action == Online && index == -1 {
				slice.Slaves = append(slice.Slaves, oldAddr)
				isModify = true
			} else if action == Offline && index != -1 {
				slice.Slaves = append(slice.Slaves[:index], slice.Slaves[index+1:]...)
				isModify = true
			}

		}
		if isModify {
			err = ModifyNamespace(namespace, cfg, cluster)
			isModify = false
			if err != nil {
				log.Warn("namespace:%s modifyNamespace failed, err: %v", namespace.Name, err)
				return err
			}
		}
	}
	return nil
}

func OnlineOrOfflineSlaveIpNotMasterDC(names []string, cfg *models.CCConfig, cluster, oldAddr, action string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	isModify := false
	for _, namespace := range namespaces {
		for _, slice := range namespace.Slices {
			index := -1
			for k, v := range slice.SlaveDCSlaves {
				if v == oldAddr {
					index = k
				}
			}
			if action == Online {
				if slice.SlaveDCMaster == "" {
					slice.SlaveDCMaster = oldAddr
				}
				if index == -1 {
					slice.SlaveDCSlaves = append(slice.SlaveDCSlaves, oldAddr)
					isModify = true
				}
			} else if action == Offline {
				if slice.SlaveDCMaster == oldAddr {
					slice.SlaveDCMaster = ""
					isModify = true
				}
				if index != -1 {
					slice.SlaveDCSlaves = append(slice.SlaveDCSlaves[:index], slice.SlaveDCSlaves[index+1:]...)
					isModify = true
				}
			}

		}
		if isModify {
			err = ModifyNamespace(namespace, cfg, cluster)
			isModify = false
			if err != nil {
				log.Warn("namespace:%s modifyNamespace failed, err: %v", namespace.Name, err)
				return err
			}
		}
	}
	return nil
}

func AddAllowedIp(names []string, cfg *models.CCConfig, cluster, allowedIp string) error {
	namespaces, err := QueryNamespace(names, cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		return err
	}
	isModify := false
	for _, namespace := range namespaces {
		index := -1
		for k, v := range namespace.AllowedIP {
			if v == allowedIp {
				index = k
			}
		}
		if index == -1 {
			namespace.AllowedIP = append(namespace.AllowedIP, allowedIp)
			isModify = true
		}

		if isModify {
			err = ModifyNamespace(namespace, cfg, cluster)
			isModify = false
			if err != nil {
				log.Warn("namespace:%s modifyNamespace failed, err: %v", namespace.Name, err)
				return err
			}
		}
	}
	return nil
}
