/// Ref: https://medium.com/nervosnetwork/whats-animagus-part-2-running-it-for-real-17a48608389d#6aaf

func buildExecutionNode(_ queryCellNode: Ast_Value) -> Ast_Value {
    let getCapacityFunction = buildAst(.getCapacity) {
        $0.children = [
            buildAst(.arg) { $0.u = 0 }
        ]
    }
    let capacities = buildAst(.map) {
        $0.children = [
            getCapacityFunction,
            queryCellNode
        ]
    }

    let addBalanceFunction = buildAst(.add) {
        $0.children = [
            buildAst(.arg) { $0.u = 0 },
            buildAst(.arg) { $0.u = 1 }
        ]
    }

    let initialBalance = buildAst(.uint64) {
        $0.u = 0
    }

    return buildAst(.reduce) {
        $0.children = [
            addBalanceFunction,
            initialBalance,
            capacities
        ]
    }
}

func buildRoot(_ name: String, _ node: Ast_Value) -> Ast_Root {
    var call = Ast_Call()
    call.name = name
    call.result = node

    var root = Ast_Root()
    root.calls = [call]
    return root
}
