// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WordsStateRepository",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WordsStateRepository",
            targets: ["WordsStateRepository"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.1.0"),
        .package(url: "https://github.com/Sergey231/LexickonApi.git", from: "0.5.9"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .revision("c244d3275ab5d88c3355c907acd9be687feccb50"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WordsStateRepository",
            dependencies: [
                .product(name: "RxCocoa", package: "RxSwift"),
                "LexickonApi",
                "Alamofire"
            ]),
        .testTarget(
            name: "WordsStateRepositoryTests",
            dependencies: ["WordsStateRepository"]),
    ]
)
