
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
            url: "https://github.com/Desp0o/izziRequest/releases/download/v1.2.0/izziRequest.xcframework.zip",
            checksum: "1a232b7c97e493fc1640990f4e908cafb28f6848447b9ca061a9ec4636db7a79"
        )
    ]
)
