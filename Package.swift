// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "IzziRequest",
  platforms: [
    .iOS(.v15),
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "IzziRequest",
      targets: ["IzziRequest"]
    ),
  ],
  targets: [
    .target(
      name: "IzziRequest",
      path: "Sources/IzziRequest"
    )
  ]
)
