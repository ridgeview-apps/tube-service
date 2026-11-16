// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "SeedData",
    platforms: [
        .macOS(.v15)
    ],
    targets: [
        .target(name: "SeedDataCore"),
        .executableTarget(
            name: "seed-data",
            dependencies: ["SeedDataCore"]
        ),
        .testTarget(
            name: "SeedDataCoreTests",
            dependencies: ["SeedDataCore"]
        )
    ]
)
