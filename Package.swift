// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "pwnedpasswords",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "PwnedPasswords", targets: ["PwnedPasswords"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0"),
    ],
    targets: [
        .target(name: "PwnedPasswords", dependencies: [
            .product(name: "Crypto", package: "swift-crypto"),
        ])
    ]
)
