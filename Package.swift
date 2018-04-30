// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Vapor3Authentication",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2"),

        // 🍃 Leaf template engine.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2"),

        // Auth
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc.3.1")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "FluentSQLite", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

