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

package cc

import (
	"fmt"
	"github.com/spf13/cast"
	"net"
	"net/http"
	"strings"

	"github.com/gin-contrib/gzip"
	"github.com/gin-gonic/gin"

	"github.com/nicholaskh/dbproxy/cc/service"
	"github.com/nicholaskh/dbproxy/log"
	"github.com/nicholaskh/dbproxy/models"
)

// Server admin server
type Server struct {
	cfg *models.CCConfig

	engine   *gin.Engine
	listener net.Listener

	exitC chan struct{}
}

// RetHeader response header
type RetHeader struct {
	RetCode    int    `json:"ret_code"`
	RetMessage string `json:"ret_message"`
}

const (
	masterDC    = 0
	notMasterDC = 1
)

// NewServer constructor of Server
func NewServer(addr string, cfg *models.CCConfig) (*Server, error) {
	srv := &Server{cfg: cfg, exitC: make(chan struct{})}
	srv.engine = gin.New()

	l, err := net.Listen("tcp", addr)
	if err != nil {
		return nil, err
	}
	srv.listener = l
	srv.registerURL()
	return srv, nil
}

func (s *Server) registerURL() {
	api := s.engine.Group("/api/cc", gin.BasicAuth(gin.Accounts{s.cfg.AdminUserName: s.cfg.AdminPassword}))
	api.Use(gin.Recovery())
	api.Use(gzip.Gzip(gzip.DefaultCompression))
	api.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Content-Type", "application/json; charset=utf-8")
	})
	api.GET("/namespace/list", s.listNamespace)
	api.GET("/namespace", s.queryNamespace)
	api.GET("/namespace/detail/:name", s.detailNamespace)
	api.PUT("/namespace/modify", s.modifyNamespace)
	api.PUT("/namespace/delete/:name", s.delNamespace)
	api.GET("/namespace/sqlfingerprint/:name", s.sqlFingerprint)
	api.GET("/proxy/config/fingerprint", s.proxyConfigFingerprint)
	api.PUT("/namespace/promoteDCForSingleNamespace/:name", s.promoteDCForSingleNamespace)
	api.PUT("/namespace/promoteDCForAllNamespaces", s.promoteDCForAllNamespaces)
	api.PUT("/namespace/resumeDCForSingleNamespace/:name", s.ResumeDCForSingleNamespace)
	api.PUT("/namespace/resumeDCForAllNamespaces", s.ResumeDCForAllNamespaces)
	api.PUT("/namespace/switchMasterSlaveForCluster", s.SwitchMasterSlaveForCluster)
	api.PUT("/namespace/forceMasterForSingleNamespace/:name", s.forceMasterForSingleNamespace)
	api.PUT("/namespace/cancelForceMasterForSingleNamespace/:name", s.cancelForceMasterForSingleNamespace)
	api.PUT("/namespace/replaceMasterIp", s.replaceMasterIp)
	api.PUT("/namespace/onlineOrOfflineSlaveIp", s.onlineOrOfflineSlaveIp)
	api.PUT("/namespace/addAllowedIp", s.addAllowedIp)

}

// ListNamespaceResp list names of all namespace response
type ListNamespaceResp struct {
	RetHeader *RetHeader `json:"ret_header"`
	Data      []string   `json:"data"`
}

func (s *Server) SwitchMasterSlaveForCluster(c *gin.Context) {
	h := &RetHeader{RetCode: -1, RetMessage: ""}

	newIp := strings.TrimSpace(c.PostForm("new_ip"))
	newPort := strings.TrimSpace(c.PostForm("new_port"))
	oldIp := strings.TrimSpace(c.PostForm("old_ip"))
	oldPort := strings.TrimSpace(c.PostForm("old_port"))
	cluster := c.PostForm("cluster")

	if newIp == "" || newPort == "" || oldIp == "" || oldPort == "" {
		log.Warn("params is empty")
		h.RetMessage = "params is empty!"
		c.JSON(http.StatusBadRequest, h)
		return
	}

	oldAddr := oldIp + ":" + oldPort
	newAddr := newIp + ":" + newPort
	log.Warn("oldAddr:%s,newAddr:%s,cluster:%s", oldAddr, newAddr, cluster)

	names, err := service.ListNamespace(s.cfg, cluster)
	if err != nil {
		errMsg := fmt.Sprintf("list cluster namespace failed, %v", err)
		log.Warn(errMsg)
		h.RetMessage = errMsg
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}

	if len(names) < 1 {
		log.Warn("names is not exists")
		h.RetMessage = "names is not exists"
		c.JSON(http.StatusBadRequest, h)
		return
	}

	err = service.SwitchMasterSlave(names, s.cfg, cluster, oldAddr, newAddr)

	if err != nil {
		log.Warn("SwitchDc failed, err: %v", err)
		h.RetMessage = err.Error()
		h.RetCode = -2 //modifyNamespace failed
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

/**
恢复某一个namespace的主从机房
*/
func (s *Server) ResumeDCForSingleNamespace(c *gin.Context) {
	var names []string
	h := &RetHeader{RetCode: -1, RetMessage: ""}

	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		h.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, h)
		return
	}

	names = append(names, name)

	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	err := service.ResumeDc(names, s.cfg, cluster)
	if err != nil {
		log.Warn("SwitchDc failed, err: %v", err)
		h.RetMessage = err.Error()
		c.JSON(http.StatusOK, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

/**
恢复所有namespace的主从机房
*/
func (s *Server) ResumeDCForAllNamespaces(c *gin.Context) {
	var names []string
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	clusters, err := service.ListCluster(s.cfg, "")
	if err != nil {
		errMsg := fmt.Sprintf("list namespace failed, %v", err)
		log.Warn(errMsg)
		h.RetMessage = errMsg
		c.JSON(http.StatusOK, h)
		return
	}

	for _, cluster := range clusters {
		names, err = service.ListNamespace(s.cfg, cluster)
		if err != nil {
			errMsg := fmt.Sprintf("list cluster namespace failed, %v", err)
			log.Warn(errMsg)
			h.RetMessage = errMsg
			c.JSON(http.StatusOK, h)
			return
		}

		err = service.ResumeDc(names, s.cfg, cluster)
		if err != nil {
			log.Warn("SwitchDc failed, err: %v", err)
			h.RetMessage = err.Error()
			c.JSON(http.StatusOK, h)
			return
		}
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return

}

/**
切换某一个namespace的主从机房
*/
func (s *Server) promoteDCForSingleNamespace(c *gin.Context) {
	var names []string
	h := &RetHeader{RetCode: -1, RetMessage: ""}

	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		h.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, h)
		return
	}

	names = append(names, name)

	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	err := service.PromoteDc(names, s.cfg, cluster)
	if err != nil {
		log.Warn("SwitchDc failed, err: %v", err)
		h.RetMessage = err.Error()
		c.JSON(http.StatusOK, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

func (s *Server) forceMasterForSingleNamespace(c *gin.Context) {

	h := &RetHeader{RetCode: -1, RetMessage: ""}

	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		h.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, h)
		return
	}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	err := service.ForceMasterForSingleNamespace(name, s.cfg, cluster)
	if err != nil {
		log.Warn("forceMasterForSingleNamespace failed, err: %v", err)
		h.RetMessage = err.Error()
		c.JSON(http.StatusOK, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

func (s *Server) cancelForceMasterForSingleNamespace(c *gin.Context) {

	h := &RetHeader{RetCode: -1, RetMessage: ""}

	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		h.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, h)
		return
	}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	err := service.CancelForceMasterForSingleNamespace(name, s.cfg, cluster)
	if err != nil {
		log.Warn("cancelForceMasterForSingleNamespace failed, err: %v", err)
		h.RetMessage = err.Error()
		c.JSON(http.StatusOK, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

func (s *Server) replaceMasterIp(c *gin.Context) {
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	newIp := strings.TrimSpace(c.PostForm("new_ip"))
	newPort := strings.TrimSpace(c.PostForm("new_port"))
	oldIp := strings.TrimSpace(c.PostForm("old_ip"))
	oldPort := strings.TrimSpace(c.PostForm("old_port"))
	cluster := strings.TrimSpace(c.PostForm("cluster"))
	if newIp == "" || newPort == "" || oldIp == "" || oldPort == "" {
		log.Warn("params is empty")
		h.RetMessage = "params is empty!"
		c.JSON(http.StatusBadRequest, h)
		return
	}
	oldAddr := oldIp + ":" + oldPort
	newAddr := newIp + ":" + newPort
	if oldAddr == newAddr {
		log.Warn("oldAdd is newAddr")
		h.RetMessage = "oldAdd is newAddr!"
		c.JSON(http.StatusBadRequest, h)
		return
	}

	log.Notice("oldAddr:%s,newAddr:%s,cluster:%s", oldAddr, newAddr, cluster)

	names, err := service.ListNamespace(s.cfg, cluster)
	if err != nil {
		errMsg := fmt.Sprintf("list cluster namespace failed, %v", err)
		log.Warn(errMsg)
		h.RetMessage = errMsg
		c.JSON(http.StatusBadRequest, h)
		return
	}

	if len(names) < 1 {
		log.Warn("names is not exists")
		h.RetMessage = "names is not exists"
		c.JSON(http.StatusBadRequest, h)
		return
	}

	err = service.ReplaceMasterIp(names, s.cfg, cluster, oldAddr, newAddr)

	if err != nil {
		log.Warn("Replace failed, err: %v", err)
		h.RetMessage = err.Error()
		h.RetCode = -2 //modifyNamespace failed
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

func (s *Server) onlineOrOfflineSlaveIp(c *gin.Context) {
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	oldIp := strings.TrimSpace(c.PostForm("old_ip"))
	oldPort := strings.TrimSpace(c.PostForm("old_port"))
	cluster := strings.TrimSpace(c.PostForm("cluster"))
	addressNumber := strings.TrimSpace(c.PostForm("address_number"))
	action := strings.TrimSpace(c.PostForm("action"))
	oldAddr := oldIp + ":" + oldPort
	log.Notice("oldAddr:%s,newAddr:%s,cluster:%s", oldAddr, cluster)
	names, err := service.ListNamespace(s.cfg, cluster)
	if err != nil {
		errMsg := fmt.Sprintf("list cluster namespace failed, %v", err)
		log.Warn(errMsg)
		h.RetMessage = errMsg
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}
	if len(names) < 1 {
		log.Warn("names is not exists")
		h.RetMessage = "names is not exists"
		c.JSON(http.StatusBadRequest, h)
		return
	}
	if cast.ToInt(addressNumber) == masterDC {
		err = service.OnlineOrOfflineSlaveIpMasterDC(names, s.cfg, cluster, oldAddr, action)
	} else if cast.ToInt(addressNumber) == notMasterDC {
		err = service.OnlineOrOfflineSlaveIpNotMasterDC(names, s.cfg, cluster, oldAddr, action)
	} else {
		log.Warn("addressNumber is not found")
		h.RetMessage = "addressNumber is not found"
		c.JSON(http.StatusBadRequest, h)
		return
	}
	if err != nil {
		log.Warn("OnlineOrOfflineSlaveIp failed, err: %v", err)
		h.RetMessage = err.Error()
		h.RetCode = -2 //modifyNamespace failed
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}
	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

func (s *Server) addAllowedIp(c *gin.Context) {
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	cluster := strings.TrimSpace(c.PostForm("cluster"))
	allowedIp := strings.TrimSpace(c.PostForm("allowed_ip"))
	log.Notice("addAllowedIp allowedIp:%s,cluster:%s", allowedIp, cluster)
	names, err := service.ListNamespace(s.cfg, cluster)
	if err != nil {
		errMsg := fmt.Sprintf("list cluster namespace failed, %v", err)
		log.Warn(errMsg)
		h.RetMessage = errMsg
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}
	if len(names) < 1 {
		log.Warn("names is not exists")
		h.RetMessage = "names is not exists"
		c.JSON(http.StatusBadRequest, h)
		return
	}

	err = service.AddAllowedIp(names, s.cfg, cluster, allowedIp)
	if err != nil {
		log.Warn("addAllowedIp failed, err: %v", err)
		h.RetMessage = err.Error()
		h.RetCode = -2 //modifyNamespace failed
		c.JSON(http.StatusServiceUnavailable, h)
		return
	}
	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

/**
切换所有namespace的主从机房
*/
func (s *Server) promoteDCForAllNamespaces(c *gin.Context) {
	var names []string
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	clusters, err := service.ListCluster(s.cfg, "")
	if err != nil {
		errMsg := fmt.Sprintf("list namespace failed, %v", err)
		log.Warn(errMsg)
		h.RetMessage = errMsg
		c.JSON(http.StatusOK, h)
		return
	}

	for _, cluster := range clusters {
		names, err = service.ListNamespace(s.cfg, cluster)
		if err != nil {
			errMsg := fmt.Sprintf("list cluster namespace failed, %v", err)
			log.Warn(errMsg)
			h.RetMessage = errMsg
			c.JSON(http.StatusOK, h)
			return
		}

		err = service.PromoteDc(names, s.cfg, cluster)
		if err != nil {
			log.Warn("SwitchDc failed, err: %v", err)
			h.RetMessage = err.Error()
			c.JSON(http.StatusOK, h)
			return
		}
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

// return names of all namespace
func (s *Server) listNamespace(c *gin.Context) {
	var err error
	r := &ListNamespaceResp{RetHeader: &RetHeader{RetCode: -1, RetMessage: ""}}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	r.Data, err = service.ListNamespace(s.cfg, cluster)
	if err != nil {
		log.Warn("list names of all namespace failed, %v", err)
		r.RetHeader.RetMessage = err.Error()
		c.JSON(http.StatusOK, r)
		return
	}
	r.RetHeader.RetCode = 0
	r.RetHeader.RetMessage = "SUCC"
	c.JSON(http.StatusOK, r)
	return
}

// QueryReq query namespace request
type QueryReq struct {
	Names []string `json:"names"`
}

// QueryNamespaceResp query namespace response
type QueryNamespaceResp struct {
	RetHeader *RetHeader          `json:"ret_header"`
	Data      []*models.Namespace `json:"data"`
}

func (s *Server) queryNamespace(c *gin.Context) {
	var err error
	var req QueryReq
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	r := &QueryNamespaceResp{RetHeader: h}

	err = c.BindJSON(&req)
	if err != nil {
		log.Warn("queryNamespace got invalid data, err: %v", err)
		h.RetMessage = err.Error()
		c.JSON(http.StatusBadRequest, r)
		return
	}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	r.Data, err = service.QueryNamespace(req.Names, s.cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		c.JSON(http.StatusOK, r)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, r)
	return
}

func (s *Server) detailNamespace(c *gin.Context) {
	var err error
	var names []string
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	r := &QueryNamespaceResp{RetHeader: h}

	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		h.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, h)
		return
	}

	names = append(names, name)
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	r.Data, err = service.QueryNamespace(names, s.cfg, cluster)
	if err != nil {
		log.Warn("query namespace failed, %v", err)
		c.JSON(http.StatusOK, r)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, r)
	return
}

func (s *Server) modifyNamespace(c *gin.Context) {
	var err error
	var namespace models.Namespace
	h := &RetHeader{RetCode: -1, RetMessage: ""}

	err = c.BindJSON(&namespace)
	if err != nil {
		log.Warn("modifyNamespace failed, err: %v", err)
		c.JSON(http.StatusBadRequest, h)
		return
	}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	err = service.ModifyNamespace(&namespace, s.cfg, cluster)
	if err != nil {
		log.Warn("modifyNamespace failed, err: %v", err)
		h.RetMessage = err.Error()
		c.JSON(http.StatusOK, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

func (s *Server) delNamespace(c *gin.Context) {
	var err error
	h := &RetHeader{RetCode: -1, RetMessage: ""}
	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		h.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, h)
		return
	}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	err = service.DelNamespace(name, s.cfg, cluster)
	if err != nil {
		h.RetMessage = fmt.Sprintf("delete namespace faild, %v", err.Error())
		c.JSON(http.StatusOK, h)
		return
	}

	h.RetCode = 0
	h.RetMessage = "SUCC"
	c.JSON(http.StatusOK, h)
	return
}

type sqlFingerprintResp struct {
	RetHeader *RetHeader        `json:"ret_header"`
	ErrSQLs   map[string]string `json:"err_sqls"`
	SlowSQLs  map[string]string `json:"slow_sqls"`
}

func (s *Server) sqlFingerprint(c *gin.Context) {
	var err error
	r := &sqlFingerprintResp{RetHeader: &RetHeader{RetCode: -1, RetMessage: ""}}
	name := strings.TrimSpace(c.Param("name"))
	if name == "" {
		r.RetHeader.RetMessage = "input name is empty"
		c.JSON(http.StatusOK, r)
		return
	}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	r.SlowSQLs, r.ErrSQLs, err = service.SQLFingerprint(name, s.cfg, cluster)
	if err != nil {
		r.RetHeader.RetMessage = err.Error()
		c.JSON(http.StatusOK, r)
		return
	}
	r.RetHeader.RetCode = 0
	r.RetHeader.RetMessage = "SUCC"
	c.JSON(http.StatusOK, r)
	return
}

type proxyConfigFingerprintResp struct {
	RetHeader *RetHeader        `json:"ret_header"`
	Data      map[string]string `json:"data"` // key: ip:port value: md5 of config
}

func (s *Server) proxyConfigFingerprint(c *gin.Context) {
	var err error
	r := &proxyConfigFingerprintResp{RetHeader: &RetHeader{RetCode: -1, RetMessage: ""}}
	cluster := c.DefaultQuery("cluster", s.cfg.DefaultCluster)
	r.Data, err = service.ProxyConfigFingerprint(s.cfg, cluster)
	if err != nil {
		r.RetHeader.RetMessage = err.Error()
		c.JSON(http.StatusOK, r)
		return
	}
	r.RetHeader.RetCode = 0
	r.RetHeader.RetMessage = "SUCC"
	c.JSON(http.StatusOK, r)
	return
}

func (s *Server) Run() {
	defer s.listener.Close()

	errC := make(chan error)

	go func(l net.Listener) {
		h := http.NewServeMux()
		h.Handle("/", s.engine)
		hs := &http.Server{Handler: h}
		errC <- hs.Serve(l)
	}(s.listener)

	select {
	case <-s.exitC:
		log.Notice("server exit.")
		return
	case err := <-errC:
		log.Fatal("gaea cc serve failed, %v", err)
		return
	}

}

func (s *Server) Close() {
	s.exitC <- struct{}{}
	return
}
