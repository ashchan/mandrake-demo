//
//  Unlock.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/18.
//

import SwiftUI

struct Events: View {
    @EnvironmentObject private var dao: DaoService

    var body: some View {
        HStack {
            VStack {
                Text("Deposit")
                    .font(.headline)
                    .padding(10)
                List(dao.depositEvents, id: \.id) { event in
                    Row(cell: event)
                }
            }

            VStack {
                Text("Withdraw")
                    .font(.headline)
                    .padding(10)
                List(dao.withdrawEvents, id: \.id) { event in
                    Row(cell: event)
                }
            }

            VStack {
                Text("Unlock")
                    .font(.headline)
                    .padding(10)
                List(dao.unlockEvents, id: \.id) { event in
                    Row(cell: event)
                }
            }
        }
        .navigationTitle("DAO Events")
    }
}

struct Row: View {
    var cell: Cell

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
                Text(cell.balance.formatted)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                Text(cell.txHash)
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
        }
        .onTapGesture(count: 2, perform: {
            let url = URL(string: "https://explorer.nervos.org/transaction/\(cell.txHash)")!
            NSWorkspace.shared.open(url)
        })
        .padding(20)
    }
}

struct Unlock_Previews: PreviewProvider {
    static var previews: some View {
        Events()
    }
}
