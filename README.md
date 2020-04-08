
# Animagus Swift Example

Try out [Animagus](https://github.com/xxuejie/animagus), a new dapp framework.

## Install dependencies

* [Swift Protobuf](https://github.com/apple/swift-protobuf)
* [gRPC Swift](https://github.com/grpc/grpc-swift)

## Generate proto types

*Already checked in.*

```shell
protoc -I ../animagus/protos ast.proto --swift_out=./Sources/AnimagusExample --grpc-swift_out=./Sources/AnimagusExample
protoc -I ../animagus/protos generic.proto --swift_out=./Sources/AnimagusExample --grpc-swift_out=./Sources/AnimagusExample
```