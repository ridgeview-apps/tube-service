// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataClients",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "DataClients",
            targets: ["DataClients"]),
    ],
    dependencies: [
        .package(name: "Model", path: "../Model"),
        .package(name: "Shared", path: "../Shared"),
        .package(
            url: "https://github.com/ridgeview-apps/ridgeview-core",
            branch: "main"
        ),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.0")
//        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "DataClients",
            dependencies: [
                .product(name: "Model", package: "Model"),
                .product(name: "Shared", package: "Shared"),
                .product(name: "RidgeviewCore", package: "ridgeview-core"),
//                .product(name: "IdentifiedCollections", package: "swift-identified-collections")
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "DataClientsTests",
            dependencies: [
                "DataClients",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]),
    ]
)
