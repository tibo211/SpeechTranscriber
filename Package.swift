// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeechTranscriber",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "SpeechTranscriber",
            targets: ["SpeechTranscriber"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MacPaw/OpenAI",
                 branch: "main")
    ],
    targets: [
        .target(
            name: "SpeechTranscriber",
            dependencies: ["OpenAI"]
        ),
        .testTarget(
            name: "SpeechTranscriberTests",
            dependencies: ["SpeechTranscriber"],
        resources: [
            .copy("transcribing.mp3")
        ]),
    ]
)
