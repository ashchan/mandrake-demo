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
    @Published var balanceHistory: [UInt64] = []

    @Published var depositEvents: [Cell] = []
    @Published var withdrawEvents: [Cell] = []
    @Published var unlockEvents: [Cell] = []

    // Change when deposit/unlock events are received
    private let subject = PassthroughSubject<TimeInterval, Never>()
    private var cancellables: [AnyCancellable] = []
    private let listLimit = 30

    func start() {
        let interval = TimeInterval(2)
        cancellables.append(
            subject
                .throttle(for: .seconds(interval), scheduler: RunLoop.main, latest: true)
                .sink { _ in
                    self.fetchBalance()
                }
        )
        cancellables.append(
            subject
                .throttle(for: .seconds(interval), scheduler: RunLoop.main, latest: true)
                .sink { _ in
                    self.recordHistory()
                }
        )

        fetchBalance()
        listenDepositEvents()
        listenWithdrawEvents()
        listenUnlockEvents()
    }
}

private extension DaoService {
    func recordHistory() {
        balanceHistory.append(balance)
    }

    func fetchBalance() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "balance"
            let response = try! self.client.call(request).response.wait()
            DispatchQueue.main.async {
                self.balance = response.u
            }
        }
    }

    func listenDepositEvents() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "deposit"
            let stream = self.client.stream(request) { value in
                let cell = Cell.fromAstValue(value)
                print("Deposit \(cell.txHash)")
                DispatchQueue.main.async {
                    self.depositEvents.insert(cell, at: 0)
                    let count = self.depositEvents.count
                    if (count > self.listLimit) {
                        self.depositEvents.removeLast(count - self.listLimit)
                    }
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
                let cell = Cell.fromAstValue(value)
                print("Withdraw \(cell.txHash)")
                DispatchQueue.main.async {
                    self.withdrawEvents.insert(cell, at: 0)
                    let count = self.withdrawEvents.count
                    if (count > self.listLimit) {
                        self.withdrawEvents.removeLast(count - self.listLimit)
                    }
                }
            }

            _ = try! stream.status.wait()
        }
    }

    func listenUnlockEvents() {
        DispatchQueue.global(qos: .userInitiated).async {
            var request = Generic_GenericParams()
            request.name = "unlock"
            let stream = self.client.stream(request) { value in
                let cell = Cell.fromAstValue(value)
                print("Unlock \(cell.txHash)")
                DispatchQueue.main.async {
                    self.unlockEvents.insert(cell, at: 0)
                    let count = self.unlockEvents.count
                    if (count > self.listLimit) {
                        self.unlockEvents.removeLast(count - self.listLimit)
                    }
                    self.subject.send(Date().timeIntervalSince1970)
                }
            }

            _ = try! stream.status.wait()
        }
    }
}

extension DaoService {
    static var example: DaoService = {
        let dao = DaoService()
        let decimal = UInt64(1_00_000_000)
        dao.balance = 6_000_000_000 * decimal
        dao.balanceHistory = [
            4_000_000_000 * decimal,
            5_000_000_000 * decimal,
            6_000_000_000 * decimal,
            4_000_000_000 * decimal,
            5_000_000_000 * decimal,
        ]
        dao.depositEvents = [
            Cell(balance: 1_000 * decimal, txHash: "0xabcd...eeff", index: 0),
            Cell(balance: 2_000 * decimal, txHash: "0xabcd...ffff", index: 0),
            Cell(balance: 3_000 * decimal, txHash: "0xabcd...eeee", index: 0)
        ]
        dao.withdrawEvents = [
            Cell(balance: 2_000 * decimal, txHash: "0xabcd...eeff", index: 0)
        ]
        dao.unlockEvents = [
            Cell(balance: 3_000 * decimal, txHash: "0xabcd...eeff", index: 0)
        ]
        return dao
    }()
}
