// swift-tools-version:5.2
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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.29.1"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "1.0.2")
    ],
    targets: [
        .target(name: "PwnedPasswords", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Crypto", package: "swift-crypto"),
        ])
    ]
)
