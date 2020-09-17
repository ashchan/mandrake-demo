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

    func test() {
        var request = Generic_GenericParams()

        request.name = "dao deposit"
        do {
            let response = try client.call(request).response.wait()
            print(response)
        } catch {
            print(error)
        }

        request.name = "unlock"
        let stream = client.stream(request) { value in
            print(value)
        }
        stream.status.whenSuccess { (s) in
            print(s)
        }

        _ = try! stream.status.wait()
    }
}
