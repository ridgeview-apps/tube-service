// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationViews",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "PresentationViews", targets: ["PresentationViews"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "Shared"),
        .package(path: "Models")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PresentationViews",
            dependencies: [
                "Shared",
                .product(name: "Models", package: "Models"),
                .product(name: "ModelStubs", package: "Models")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "PresentationViewsTests",
            dependencies: ["PresentationViews"]
        )
    ]
)
