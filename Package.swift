
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
            url: "https://github.com/Desp0o/izziRequest/releases/download/v2.0.0/izziRequest.xcframework.zip",
            checksum: "7197d731e65d6a63fe8b5e05d49b5d1fbbdb6d54fca4232b8a6ae385d3def6f4"
        )
    ]
)
