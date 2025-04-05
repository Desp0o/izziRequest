
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
            url: "https://github.com/Desp0o/izziRequest/releases/download/v1.1.1/izziRequest.xcframework.zip",
            checksum: "a71390582f1268526c47b614e084b85ed5fb821dabc455b872c3f537c3c331b6"
        )
    ]
)
