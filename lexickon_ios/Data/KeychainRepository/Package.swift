// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeychainRepository",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KeychainRepository",
            targets: ["KeychainRepository"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", from: "4.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KeychainRepository",
            dependencies: ["SwiftKeychainWrapper"]),
        .testTarget(
            name: "KeychainRepositoryTests",
            dependencies: ["KeychainRepository"]),
    ]
)
