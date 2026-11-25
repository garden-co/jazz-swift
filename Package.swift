// swift-tools-version:6.0
// Jazz for Swift 2.0.0-beta.4: the mirror of packages/jazz-swift in
// garden-co/jazz, published by .github/workflows/swift-mirror.yml. Do not
// edit here: change garden-co/jazz.
//
//     .package(url: "https://github.com/garden-co/jazz-swift", exact: "2.0.0-beta.4")
//
// On Apple platforms the Jazz core (libjazz_ffi) is the prebuilt
// JazzFFI.xcframework attached to the release. Elsewhere (Linux) it's a
// system library found through pkg-config: build it with
// packages/jazz-swift/scripts/build-ffi.sh --lib-only from garden-co/jazz at
// the same version, and set PKG_CONFIG_PATH.
import PackageDescription

#if canImport(Darwin)
    let jazzFFI: Target = .binaryTarget(
        name: "jazz_ffiFFI", url: "https://github.com/garden-co/jazz/releases/download/v2.0.0-beta.4/JazzFFI.xcframework.zip", checksum: "a274a5254906dc8f2dbe280587a5829e248428db51f72a8734df14c1f95c9eb7")
#else
    let jazzFFI: Target = .systemLibrary(name: "jazz_ffiFFI", path: "Sources/jazz_ffiFFI", pkgConfig: "jazz_ffi")
#endif

/// What the Rust core needs from Apple's SDK.
let appleLinks: [LinkerSetting] = [
    .linkedFramework("CoreFoundation", .when(platforms: [.macOS, .iOS])),
    .linkedFramework("Security", .when(platforms: [.macOS, .iOS])),
    .linkedFramework("SystemConfiguration", .when(platforms: [.macOS, .iOS])),
    .linkedLibrary("iconv", .when(platforms: [.macOS, .iOS])),
    .linkedLibrary("resolv", .when(platforms: [.macOS, .iOS])),
]

let package = Package(
    name: "jazz-swift",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [.library(name: "Jazz", targets: ["Jazz"])],
    targets: [
        .target(name: "Jazz", dependencies: ["JazzFFI"]),
        .target(name: "JazzFFI", dependencies: ["jazz_ffiFFI"], linkerSettings: appleLinks),
        jazzFFI,
    ]
)
