//
//  Balance.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/18.
//

import SwiftUI

struct Balance: View {
    @EnvironmentObject private var dao: DaoService

    var body: some View {
        Group {
            HStack {
                Text("DAO Deposit: ")
                    .font(.system(size: 20))
                Text(dao.balance.formatted)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
            }
        }
        .navigationTitle("Deposit")
    }
}

struct Balance_Previews: PreviewProvider {
    static var previews: some View {
        Balance()
    }
}
