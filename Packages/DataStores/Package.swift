// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataStores",
    platforms: [
        .iOS("16.4")
    ],
    products: [
        .library(name: "DataStores", targets: ["DataStores"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ridgeview-apps/ridgeview-core", branch: "main"),
        .package(path: "Models"),
        .package(path: "Shared")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DataStores",
            dependencies: ["Models",
                           "Shared",
                           .product(name: "RidgeviewCore", package: "ridgeview-core")]
        ),
        .testTarget(
            name: "DataStoresTests",
            dependencies: ["DataStores"]
        )
    ]
)
