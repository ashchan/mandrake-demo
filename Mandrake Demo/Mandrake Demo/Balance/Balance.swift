//
//  Balance.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/18.
//

import SwiftUI

struct Balance: View {
    @EnvironmentObject private var dao: DaoService
    private let base = UInt64(1_00_000_000) * UInt64(10_000_000_000)

    var body: some View {
        VStack {
            Text(dao.balance.formatted)
                .font(.system(size: 26, weight: .bold, design: .monospaced))
                .padding(20)

            GeometryReader { geomety in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 1, height: geomety.size.height)
                        ForEach(dao.balanceHistory, id: \.self) { b in
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 10, height: geomety.size.height * CGFloat(b) / CGFloat(base))
                        }
                    }
                    .background(Color.white)
                }
                .frame(height: geomety.size.height)
            }
        }
        .background(Color.white)
        .navigationTitle("DAO Deposit")
    }
}

struct Balance_Previews: PreviewProvider {
    static var previews: some View {
        Balance().environmentObject(DaoService.example)
    }
}
