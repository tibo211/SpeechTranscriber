// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol SpeechTranscriber {
    func transcribe(url: URL) async throws -> String
}
