
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "IzziRequest",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "IzziRequest", targets: ["IzziRequest"])
    ],
    targets: [
        .binaryTarget(
            name: "IzziRequest",
            url: "https://github.com/Desp0o/izziRequest/releases/download/v1.1.0/izziRequest.xcframework.zip",
            checksum: "f6e37f457b15fb67f208489929bd04065471402b9016ceb16537c22d91c08f71"
        )
    ]
)
