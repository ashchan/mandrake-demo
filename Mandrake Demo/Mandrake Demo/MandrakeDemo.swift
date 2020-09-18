//
//  MandrakeDemo.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/16.
//

import SwiftUI

@main
struct MandrakeDemo: App {
    var dao: DaoService = {
        let service = DaoService()
        service.start()
        return service
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(dao)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var dao: DaoService

    enum NavigationItem {
        case balance
        case unlock
    }
    @State private var selection: Set<NavigationItem> = [.balance]

    var body: some View {
        NavigationView {
            sidebar

            Text("Content")
        }

    }

    var sidebar: some View {
        List(selection: $selection) {
            NavigationLink(destination: Balance()) {
                Label("Deposit", systemImage: "banknote")
            }
            .accessibility(label: Text("DAO Deposit"))
            .tag(NavigationItem.balance)

            NavigationLink(destination: Unlock()) {
                Label("Withdrawal", systemImage: "gauge.badge.minus")
            }
            .accessibility(label: Text("DAO Unlock"))
            .tag(NavigationItem.unlock)
        }
        .frame(minWidth: 120)
        .listStyle(SidebarListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DaoService())
    }
}
