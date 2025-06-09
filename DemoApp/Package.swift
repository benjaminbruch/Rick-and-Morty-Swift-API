// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "RickMortyDemo",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "RickMortyDemo", targets: ["RickMortyDemo"])
    ],
    dependencies: [
        .package(path: "..")
    ],
    targets: [
        .executableTarget(
            name: "RickMortyDemo",
            dependencies: ["RickMortySwiftApi"]
        )
    ]
)
