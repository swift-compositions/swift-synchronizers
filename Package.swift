// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-synchronizers",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(name: "Synchronizer Namespace", targets: ["Synchronizer Namespace"]),

        .library(name: "Synchronizer Protocol", targets: ["Synchronizer Protocol"]),

        .library(name: "Synchronize", targets: ["Synchronize"]),

        .library(name: "Synchronizable", targets: ["Synchronizable"]),

        .library(name: "Synchronizer Blocking", targets: ["Synchronizer Blocking"]),

        .library(name: "Synchronizers", targets: ["Synchronizers"]),

        .library(name: "Synchronizers Test Support", targets: ["Synchronizers Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-compositions/swift-kernel.git", branch: "main")
    ],
    targets: [

        .target(
            name: "Synchronizer Namespace",
            dependencies: []
        ),

        .target(
            name: "Synchronizer Protocol",
            dependencies: [
                .target(name: "Synchronizer Namespace")
            ]
        ),

        .target(
            name: "Synchronize",
            dependencies: [
                .target(name: "Synchronizer Protocol")
            ]
        ),

        .target(
            name: "Synchronizable",
            dependencies: [
                .target(name: "Synchronizer Protocol")
            ]
        ),

        .target(
            name: "Synchronizer Blocking",
            dependencies: [
                .target(name: "Synchronizer Protocol"),
                .product(name: "Kernel", package: "swift-kernel"),
            ]
        ),

        .target(
            name: "Synchronizers",
            dependencies: [
                .target(name: "Synchronizer Namespace"),
                .target(name: "Synchronizer Protocol"),
                .target(name: "Synchronize"),
                .target(name: "Synchronizable"),
                .target(name: "Synchronizer Blocking"),
            ]
        ),

        .target(
            name: "Synchronizers Test Support",
            dependencies: [
                .target(name: "Synchronizers"),
                .product(name: "Kernel Test Support", package: "swift-kernel"),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Synchronize Tests",
            dependencies: [
                .target(name: "Synchronize"),
                .target(name: "Synchronizer Blocking"),
                .target(name: "Synchronizers Test Support"),
            ]
        ),
        .testTarget(
            name: "Synchronizer Blocking Tests",
            dependencies: [
                .target(name: "Synchronizer Blocking"),
                .target(name: "Synchronizers Test Support"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
