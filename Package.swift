// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PwnedPasswords",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "PwnedPasswords", targets: ["PwnedPasswords"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/apple/swift-crypto", from: "1.0.0")
    ],
    targets: [
        .target(name: "PwnedPasswords", dependencies: ["Vapor", "Crypto"]),
        .testTarget(name: "PwnedPasswordsTests", dependencies: ["Vapor", "PwnedPasswords"])
    ]
)
