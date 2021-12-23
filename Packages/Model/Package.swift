// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Model",
            targets: ["Model", "ModelFakes"]
        ),
    ],
    dependencies: [
//        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Model",
            dependencies: []
        ),
        .target(
            name: "ModelFakes",
            dependencies: ["Model"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"]
        ),
    ]
)
