// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TubeServiceLibrary",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "AppLibrary", targets: ["AppLibrary"]),
        .library(name: "DataClients", targets: ["DataClients"]),
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "Model", targets: ["Model"]),
        .library(name: "ModelFakes", targets: ["ModelFakes"]),
        .library(name: "LineStatusFeature", targets: ["LineStatusFeature"]),
        .library(name: "LiveArrivalsFeature", targets: ["LiveArrivalsFeature"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/devicekit/DeviceKit", from: "4.2.1"),
        .package(url: "https://github.com/ridgeview-apps/ridgeview-core", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.30.0"),
        .package(url: "https://github.com/microsoft/appcenter-sdk-apple.git", from: "4.0.0"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.0")
    ],
    targets: [
        // AppLibrary
        .target(
            name: "AppLibrary",
            dependencies: [
                .product(name: "RidgeviewCore", package: "ridgeview-core"),
                .product(name: "AppCenterAnalytics", package: "appcenter-sdk-apple"),
                .product(name: "AppCenterCrashes", package: "appcenter-sdk-apple"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "DataClients",
                "DeviceKit",
                "Model",
                "ModelFakes",
                "Shared",
                "LineStatusFeature",
                "LiveArrivalsFeature",
                "SettingsFeature"
            ]
        ),
        
        // DataClients
        .target(
            name: "DataClients",
            dependencies: [
                "Model",
                "ModelFakes",
                "Shared",
                .product(name: "RidgeviewCore", package: "ridgeview-core"),
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "DataClientsTests",
            dependencies: [
                "DataClients",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]),
        
        // Model
        .target(
            name: "Model",
            dependencies: []
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"]
        ),
        
        // ModelFakes
        .target(
            name: "ModelFakes",
            dependencies: ["Model"]
        ),
        
        // ModelUI
        .target(
            name: "ModelUI",
            dependencies: [
                "Model",
                "StyleGuide"
            ]
        ),
        
        // LiveArrivalsFeature
        .target(
            name: "LiveArrivalsFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "DataClients",
                "Model",
                "ModelFakes",
                "ModelUI",
                "Shared",
                "SharedViews",
                "StyleGuide",
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "LiveArrivalsFeatureTests",
            dependencies: ["LiveArrivalsFeature"]
        ),
        
        // LineStatusFeature
        .target(
            name: "LineStatusFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "DataClients",
                "Model",
                "ModelFakes",
                "ModelUI",
                "Shared",
                "SharedViews",
                "StyleGuide",
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "LineStatusFeatureTests",
            dependencies: ["LineStatusFeature"]
        ),
        
        // SettingsFeature
        .target(
            name: "SettingsFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "DataClients",
                "DeviceKit",
                "Model",
                "ModelFakes",
                "ModelUI",
                "Shared",
                "SharedViews",
                "StyleGuide"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SettingsFeatureTests",
            dependencies: ["SettingsFeature"]
        ),
        
        // Shared
        .target(
            name: "Shared",
            dependencies: []),
        .testTarget(
            name: "SharedTests",
            dependencies: ["Shared"]
        ),
        
        // SharedViews
        .target(
            name: "SharedViews",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        
        // StyleGuide
        .target(
            name: "StyleGuide",
            dependencies: [
                .product(name: "RidgeviewCore", package: "ridgeview-core"),
            ]
        ),

    ]
)
