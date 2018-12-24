// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "AmazonPriceScraper",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "Common", dependencies: ["FluentPostgreSQL", "Vapor"]),
        .target(name: "ServerApp", dependencies: ["FluentPostgreSQL", "Vapor", "Kanna", "Common"]),
        .target(name: "ServerRun", dependencies: ["ServerApp"]),
        .target(name: "ScriptRun", dependencies: ["FluentPostgreSQL", "Kanna", "Common"]),
        .testTarget(name: "ServerAppTests", dependencies: ["ServerApp"])
    ]
)

