
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
            checksum: "5caa63a17a1618fa17891e21306eec3df73603305141412b652579563f3fb5dc"
        )
    ]
)
