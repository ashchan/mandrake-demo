//
//  Animagus.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/16.
//

import Foundation
import NIO
import GRPC

class Animagus {
    var client: Generic_GenericServiceClient = {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let channel = ClientConnection.insecure(group: group)
            .connect(host: "127.0.0.1", port: 4000)
        return Generic_GenericServiceClient(channel: channel)
    }()

    func runDepositBalance() {
        var request = Generic_GenericParams()
        request.name = "deposit balance"
        let response = try! client.call(request).response.wait()
        print(response)
    }

    func runWithdrawalBalance() {
        var request = Generic_GenericParams()
        request.name = "withdrawal balance"
        let response = try! client.call(request).response.wait()
        print(response)
    }

    func runWithdrawalCells() {
        var request = Generic_GenericParams()
        request.name = "withdrawal cells"
        let response = try! client.call(request).response.wait()
        let cells = response.children.map { value in
            Cell.fromAstValue(value)
        }
        print(cells)
    }

    func runWithdrawalStream() {
        var request = Generic_GenericParams()
        request.name = "withdrawal"
        let stream = client.stream(request) { value in
            print(value)
        }
        stream.status.whenSuccess { (s) in
            print(s)
        }

        _ = try! stream.status.wait()
    }

    func runUnlockStream() {
        var request = Generic_GenericParams()
        request.name = "unlock"
        let stream = client.stream(request) { value in
            print(value)
        }
        stream.status.whenSuccess { (s) in
            print(s)
        }

        _ = try! stream.status.wait()
    }

    func test() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.runDepositBalance()
            self.runWithdrawalBalance()
            self.runWithdrawalCells()
            self.runWithdrawalStream()
            self.runUnlockStream()
        }
    }
}
