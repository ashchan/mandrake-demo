// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "animagus-swift-example",
    products: [
        .library(name: "animagus-swift-example", targets: ["AnimagusExample"]),
    ],
    dependencies: [
       // .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.8.0"),
       .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0-alpha.19"),
    ],
    targets: [
        .target(
            name: "AnimagusExample",
            dependencies: [
              // .product(name: "SwiftProtobuf", package: "swift-protobuf"),
              .product(name: "GRPC", package: "grpc-swift"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
