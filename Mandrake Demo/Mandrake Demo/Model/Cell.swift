//
//  Cell.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/17.
//

import Foundation

struct Cell {
    var balance: UInt64
    var txHash: String
    var index: UInt64

    static func fromAstValue(_ value: Ast_Value) -> Cell {
        let balance = value.children.first!.u
        let outPoint = value.children.last!
        let txHash = outPoint.children.first!.raw.toHexString()
        let index = outPoint.children.last!.u
        return Cell(balance: balance, txHash: "0x" + txHash, index: index)
    }
}
