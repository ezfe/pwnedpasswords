// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "PwnedPasswords",
    products: [
        .library(name: "PwnedPasswords", targets: ["PwnedPasswords"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
    ],
    targets: [
        .target(name: "PwnedPasswords", dependencies: ["Vapor"]),
    ]
)
