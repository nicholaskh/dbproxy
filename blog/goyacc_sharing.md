# MySQL Proxy中的分库分表
在业务开发中使用Mysql的时候，我们经常会遇到由于数据量太大而需要分表分库的场景。业内通常有一个2000W的预估，即当单表大于2000W行时，我们往往需要针对这张表做分表分库设计。其实，这个值需要根据使用场景以及单行的数据量来做判断，判断依据往往是主键索引的B+树高度。

由于分表分库涉及到诸多底层逻辑：分片规则、分片路由、数据聚合等，以及当现有架构不足以支撑业务数据拓展时，我们往往需要对现有集群扩容，比如在现有分片基础上增加新的分片。而扩容的过程中又需要涉及到数据迁移，对于业务来说，平滑的在线扩容一直以来都是一个老大难的问题。

![DB扩容.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1610423408/DB%E6%89%A9%E5%AE%B9.png)

因此我们开发了一套Mysql Proxy，来解决业务开发过程中遇到的以上诸多问题，帮助业务处理架构的底层逻辑，使业务开发能够更加聚焦于上层的业务逻辑。Mysql Proxy介绍猛戳[MySQL Proxy](https://cloud.xesv5.com/docs/mysqlproxy/)。

**那么在Mysql Proxy里我们是怎么来做分表分库呢？**

先来看这样一条SQL语句：
```SQL
SELECT * FROM users WHERE id = 10
```

我们知道，在分库分表的场景里，Mysql Proxy需要根据SQL语义识别出这条SQL是否满足分片规则，以及应该发往哪个库的哪张表。比如假设我们有4个分片库，每个分片库有32张分片表，则一共有4 * 32 = 128个逻辑分片。

如果我们的分片规则是：
```m
hash = crc32(id)

DB ID = hash % 4
Table ID = hash % 128
```

**那么问题来了：怎么提取SQL语句里的id值呢？**
**答案是：我们需要一个SQL Parser。
SQL Parser的作用是让我们能够通过代码解析，识别出SQL语句中的各个组成部分，并根据迭代语法树的结果，判断查询条件里是否有包含id列（基于AND的顶层WHERE语句）。如果确实有id列的查询，那么我们就可以把SQL语句发往特定的表。相反如果没有，那么我们需要将SQL发往所有的分片，并最终聚合，可想而知，这种情况性能是特别差的。

# yacc & lexer
我们使用的SQL解析工具是yacc。
先来看看什么是yacc。
&gt; yacc(Yet Another Compiler Compiler)，是一个经典的生成语法分析器的工具。yacc生成的编译器主要是用C语言写成的语法解析器（Parser），需要与词法解析器Lex一起使用，再把两部份产生出来的C程序一并编译。

以上是百度百科的解读。由于年代久远，语法诡异，因此一眼看去似乎学习曲线并不平缓，让人望而生畏。那么，让我们来一探究竟。

我们先来看一下yacc的执行结果：**抽象语法树（Abstract Syntax Tree，AST）**。
比如，对于以上的SQL语句，yacc执行后的结果如下：

![SelectStmtAst.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1610423764/SelectStmtAst.png)

我们看到解析结果是一棵树。树根是SelectStmt，分支分别是：
```go
type SelectStmt struct {
    SelectStmtOpts
    Fields  *FieldList
    From    *TableRefsClause
    Where   ExprNode
    OrderBy *OrderByClause
    ……
}
```

其中，我们看一下 **(4)Where条件** 里又包含了：
```go
type CompareSubqueryExpr struct {
    // L is the left expression
    L ExprNode
    // Op is the comparison opcode.
    Op opcode.Op
    // R is the subquery for right expression, may be rewritten to other type of expression.
    R ExprNode
    // All is true, we should compare all records in subquery.
    All bool
}
```

所以我们所要做的就能概括成以下的伪代码：
```go
if Where.L == "id" {
    switch Where.Op {
    case opcode.Eq:
        计算Where.R的哈希值 hash
        根据hash值计算路由分片: dbId, tableId := RouteRule(hash)
        然后将该SQL语句发往该分片
    case opcode.Lt, opcode.Gt:
	……
    }
}
```

这样，一个简单的分发器就实现了。当然，实际的Rule实现要比这个复杂的多。

# 工作流程

下面我们来看看yacc & lexer具体的执行过程：

![yacclex.png](http://ttc-tal.oss-cn-beijing.aliyuncs.com/1610438126/yacc%2Blex.png)

如上图所示，我们看到解析可分为以下几个步骤：
第一步，是给SQL语句中的每一个单词做词法分析，确定词性，类似传统语法里的“主”、“谓”、“宾”。这一步由Lex负责。
第二步，根据分析后的句法，跟相应的语法（grammar）做匹配，在匹配的过程中，生成具体的编程语言里的规则，如我们使用的Go语言的struct、int、string等。最后生成Ast抽象语法树。
Grammar语法定义如下所示：
```go
SelectStmtFromTable:
    SelectStmtBasic "FROM"
    TableRefsClause WhereClauseOptional SelectStmtGroup HavingClause WindowClauseOptional
    {
        st := $1.(*ast.SelectStmt)
        st.From = $3.(*ast.TableRefsClause)
        if st.SelectStmtOpts.TableHints != nil {
            st.TableHints = st.SelectStmtOpts.TableHints
        }
        lastField := st.Fields.Fields[len(st.Fields.Fields)-1]
        if lastField.Expr != nil && lastField.AsName.O == "" {
            lastEnd := parser.endOffset(&yyS[yypt-5])
            lastField.SetText(parser.src[lastField.Offset:lastEnd])
        }
        if $4 != nil {
            st.Where = $4.(ast.ExprNode)
        }
        if $5 != nil {
            st.GroupBy = $5.(*ast.GroupByClause)
        }
        if $6 != nil {
            st.Having = $6.(*ast.HavingClause)
        }
        if $7 != nil {
            st.WindowSpecs = ($7.([]ast.WindowSpec))
        }
        $$ = st
    }
```
第三步，根据我们定义的执行计划解析器，生成具体的执行计划。以上的SQL语句最后对对应到一个SelectPlan上。
```go
// SelectPlan is the plan for select statement
type SelectPlan struct {
    basePlan
    *TableAliasStmtInfo

    stmt *ast.SelectStmt

    distinct          bool   // 是否是SELECT DISTINCT
    groupByColumn     []int  // GROUP BY 列索引
    orderByColumn     []int  // ORDER BY 列索引
    orderByDirections []bool // ORDER BY 方向, true: DESC
    originColumnCount int    // 补列前的列长度
    columnCount       int    // 补列后的列长度

    aggregateFuncs map[int]AggregateFuncMerger // key = column index

    offset int64 // LIMIT offset
    count  int64 // LIMIT count, 未设置则为-1

    sqls map[string]map[string][]string
}
```

最后，这个解析过程就完成了。Mysql Proxy会根据以上执行计划来做相应的查询。


# goyacc
Mysql Proxy是由Go语言开发，因此我们在代码里使用的解析器是goyacc。goyacc作为Go语言官方工具集已经集成在tools包里了：[goyacc](https://github.com/golang/tools/tree/master/cmd/goyacc)。我们使用的SQL Parser库基于tidb的版本，并在此基础上做了一些二次开发，兼容更多Mysql语法。PingCap的parser库参考：[Parser](https://github.com/pingcap/parser)

yacc & Lex是编译器的经典解决方案，其中的细节繁多，感兴趣的同学可以参考图书：[yacc & lex](https://item.jd.com/10131300.html)，也欢迎找我们讨论。
