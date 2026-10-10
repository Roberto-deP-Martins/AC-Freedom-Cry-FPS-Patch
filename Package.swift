// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AC Freedom Cry 240FPS Patch",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Roberto-deP-Martins/TinyFileDialogs", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "AC_Freedom_Cry_240FPS_Patch",
            dependencies: ["TinyFileDialogs"],
        ),
        .testTarget(
            name: "AC_Freedom_Cry_240FPS_Patch_Tests",
            dependencies: ["AC_Freedom_Cry_240FPS_Patch"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
