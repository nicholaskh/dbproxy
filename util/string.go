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

package util

import (
	"bytes"

	"github.com/nicholaskh/dbproxy/util/bucketpool"
)

const (
	minBufferSize = 32
	maxBufferSize = 1024 * 1024 * 128
)

var bufPool = bucketpool.New(minBufferSize, maxBufferSize)

func Concat(strings ...string) string {
	var l int
	for _, s := range strings {
		l += len(s)
	}
	buf := bufPool.Get(l)
	defer bufPool.Put(buf)

	buffer := bytes.NewBuffer(*buf)
	buffer.Reset()
	for _, s := range strings {
		buffer.WriteString(s)
	}
	return buffer.String()
}
