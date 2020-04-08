import Foundation
import NIO
import GRPC

// writeBin() // This should write the bin file identical to the ruby example's balance.bin

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
  try? group.syncShutdownGracefully()
}

let channel = ClientConnection.insecure(group: group)
    .connect(host: "127.0.0.1", port: 4000)
defer {
  try? channel.close().wait()
}

let client = Generic_GenericServiceClient(channel: channel)

let param = buildAst(.bytes) { $0.raw = Data(hex: "903a0633f6ab457de09efb8f84dc271dc488bf62") }
var request = Generic_GenericParams()
request.name = "balance"
request.params = [param]

do {
    let result = try client.call(request).response.wait()
    print(result)
} catch {
    print(error)
}
