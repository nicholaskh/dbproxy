package plan

import (
	"github.com/dbproxy/parser/ast"
	"github.com/dbproxy/parser/format"
	"github.com/dbproxy/parser/types"
	"github.com/pingcap/errors"
	"io"
)

var (
	// type check
	_ ast.ExprNode = &InsertValuesExprDecorator{}
)

type InsertValuesExprDecorator struct {
	indexValueMap map[int][][]ast.ExprNode
	result        *RouteResult
}

func CreateInsertValuesExprDecorator(result *RouteResult, vm map[int][][]ast.ExprNode) (*InsertValuesExprDecorator, error) {
	ret := &InsertValuesExprDecorator{
		result:        result,
		indexValueMap: vm,
	}
	return ret, nil
}

func (p *InsertValuesExprDecorator) Restore(ctx *format.RestoreCtx) error {
	tableIndex, err := p.result.GetCurrentTableIndex()
	if err != nil {
		return err
	}

	if p.indexValueMap != nil {
		ctx.WriteKeyWord(" VALUES ")
		for i, row := range p.indexValueMap[tableIndex] {
			if i != 0 {
				ctx.WritePlain(",")
			}
			ctx.WritePlain("(")
			for j, v := range row {
				if j != 0 {
					ctx.WritePlain(",")
				}
				if err := v.Restore(ctx); err != nil {
					return errors.Annotatef(err, "An error occurred while restore InsertStmt.Lists[%d][%d]", i, j)
				}
			}
			ctx.WritePlain(")")
		}
	}
	return nil
}

func (p *InsertValuesExprDecorator) SetType(tp *types.FieldType) {
	panic("implement me")
}

func (p *InsertValuesExprDecorator) GetType() *types.FieldType {
	panic("implement me")
}

func (p *InsertValuesExprDecorator) SetFlag(flag uint64) {
	panic("implement me")
}

func (p *InsertValuesExprDecorator) GetFlag() uint64 {
	panic("implement me")
}

func (p *InsertValuesExprDecorator) Format(w io.Writer) {
	panic("implement me")
}

// Accept implement ast.Node
func (p *InsertValuesExprDecorator) Accept(v ast.Visitor) (node ast.Node, ok bool) {
	return p, ok
}

// Text implement ast.Node
func (p *InsertValuesExprDecorator) Text() string {
	return ""
}

// SetText implement ast.Node
func (p *InsertValuesExprDecorator) SetText(text string) {
	return
}
