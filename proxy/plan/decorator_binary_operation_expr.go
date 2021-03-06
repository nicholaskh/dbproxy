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

package plan

import (
	"github.com/nicholaskh/dbproxy/parser/ast"
	driver "github.com/nicholaskh/dbproxy/parser/tidb-types/parser_driver"
)

// BinaryOperationFieldtype declares field type of binary operation
type BinaryOperationFieldtype int

// Expr type
const (
	UnsupportExpr BinaryOperationFieldtype = iota
	ValueExpr
	ColumnNameExpr
	FuncCallExpr
)

func getExprNodeTypeInBinaryOperation(n ast.ExprNode) BinaryOperationFieldtype {
	switch n.(type) {
	case *ast.ColumnNameExpr:
		return ColumnNameExpr
	case *driver.ValueExpr:
		return ValueExpr
	case *ast.FuncCallExpr:
		return FuncCallExpr
	default:
		return UnsupportExpr
	}
}
