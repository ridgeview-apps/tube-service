// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataStores",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "DataStores", targets: ["DataStores"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ridgeview-apps/ridgeview-core", from: "1.0.0"),
        .package(path: "Shared"),
        .package(path: "Models"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DataStores",
            dependencies: [
                .product(name: "RidgeviewCore", package: "ridgeview-core"),
                "Shared",
                .product(name: "Models", package: "Models"),
                .product(name: "ModelStubs", package: "Models")
            ]
        ),
        .testTarget(
            name: "DataStoresTests",
            dependencies: ["DataStores"]
        )
    ]
)
