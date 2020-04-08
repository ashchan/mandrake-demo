/// Ref: https://medium.com/nervosnetwork/whats-animagus-part-2-running-it-for-real-17a48608389d#238d
import Foundation

func buildAst(_ t: Ast_Value.TypeEnum, builder: (inout Ast_Value) -> Void) -> Ast_Value {
    var value = Ast_Value()
    value.t = t
    builder(&value)
    return value
}

func buildQueryCellFunction() -> Ast_Value {
    let cell = buildAst(.arg) {
        $0.u = 0
    }
    let script = buildAst(.getLock) {
        $0.children = [cell]
    }

    let expectedCodeHash = Data(hex: "9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8")
    let codeHashValue = buildAst(.bytes) {
        $0.raw = expectedCodeHash
    }
    let codeHash = buildAst(.getCodeHash) {
        $0.children = [script]
    }
    let codeHashTest = buildAst(.equal) {
        $0.children = [codeHash, codeHashValue]
    }

    let hashTypeValue = buildAst(.uint64) {
        $0.u = 1
    }
    let hashType = buildAst(.getHashType) {
        $0.children = [script]
    }
    let hashTypeTest = buildAst(.equal) {
        $0.children = [hashType, hashTypeValue]
    }

    let argsValue = buildAst(.param) {
        $0.u = 0
    }
    let args = buildAst(.getArgs) {
        $0.children = [script]
    }
    let argsTest = buildAst(.equal) {
        $0.children = [args, argsValue]
    }

    return buildAst(.and) {
        $0.children = [
            codeHashTest,
            hashTypeTest,
            argsTest
        ]
    }
}

func buildQueryCell() -> Ast_Value {
    buildAst(.queryCells) {
        $0.children = [buildQueryCellFunction()]
    }
}
