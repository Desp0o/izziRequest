
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
            url: "https://github.com/Desp0o/izziRequest/releases/download/v1.0.0/izziRequest.xcframework.zip",
            checksum: "94e36ac9b2b2f0824fc63cdb400b25637b6972ad981f8415adf72367c1c81f9d"
        )
    ]
)
