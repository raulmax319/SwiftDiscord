// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDiscord",
    platforms: [
      .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftDiscord",
            targets: ["SwiftDiscord"]),
    ],
    dependencies: [
      .package(url: "https://github.com/vapor/websocket-kit.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftDiscord",
            dependencies: [
              .product(name: "WebSocketKit", package: "websocket-kit")
            ]),
        .testTarget(
            name: "SwiftDiscordTests",
            dependencies: ["SwiftDiscord"]),
    ]
)
