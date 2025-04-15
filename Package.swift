// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "izziRequest",
  platforms: [
    .iOS(.v15),
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "izziRequest",
      targets: ["izziRequest"]),
  ],
  targets: [
    .target(
      name: "izziRequest"),
    .testTarget(
      name: "izziRequestTests",
      dependencies: ["izziRequest"]
    ),
  ]
)
