//
//  Animagus.swift
//  Mandrake Demo
//
//  Created by James Chen on 2020/09/16.
//

import Foundation
import Combine
import NIO
import GRPC

class DaoService: ObservableObject {
    private var client: Generic_GenericServiceClient = {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let channel = ClientConnection.insecure(group: group)
            .connect(host: "127.0.0.1", port: 4000)
        return Generic_GenericServiceClient(channel: channel)
    }()

    @Published var balance: UInt64 = 0
    @Published var withdrawalCells: [Cell] = []

    // Change when deposit/unlock events are received
    private let subject = PassthroughSubject<TimeInterval, Never>()
    private var cancellable: AnyCancellable?

    func start() {
        cancellable = subject
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.fetchBalance()
            }

        fetchBalance()
        fetchWithdrawalCells()
        listenDepositEvents()
        listenWithdrawEvents()
        listenUnlockEvents()
    }
}

private extension DaoService {
    func fetchBalance() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "deposit balance"
            let response = try! self.client.call(request).response.wait()
            DispatchQueue.main.async {
                self.balance = response.u
            }
        }
    }

    func fetchWithdrawalCells() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "withdrawal cells"
            let response = try! self.client.call(request).response.wait()
            let cells = response.children.map { value in
                Cell.fromAstValue(value)
            }
            DispatchQueue.main.async {
                self.withdrawalCells = cells
            }
        }
    }

    func listenDepositEvents() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "deposit"
            let stream = self.client.stream(request) { value in
                print("Deposit")
                DispatchQueue.main.async {
                    self.subject.send(Date().timeIntervalSince1970)
                }
            }

            _ = try! stream.status.wait()
        }
    }

    func listenWithdrawEvents() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "withdraw"
            let stream = self.client.stream(request) { value in
                print("Withdraw")
            }

            _ = try! stream.status.wait()
        }
    }

    func listenUnlockEvents() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "unlock"
            let stream = self.client.stream(request) { value in
                print("Unlock")
                DispatchQueue.main.async {
                    self.subject.send(Date().timeIntervalSince1970)
                }
            }

            _ = try! stream.status.wait()
        }
    }
}
