//
//  WhisperSpeechTranscriber.swift
//
//
//  Created by Tibor Felföldy on 2023-12-03.
//

import Foundation
import OpenAI

public final class WhisperSpeechTranscriber: SpeechTranscriber {
    public private (set) var speeches: [Speech] = []
    
    private let openAI: OpenAI
    private let language: String?
    
    /// Init for  a `WhisperSpeechTranscriber`.
    /// - Parameter language: Input language in ISO-639-1 format.
    public init(apiToken: String, language: String? = nil) {
        openAI = OpenAI(apiToken: apiToken)
        self.language = language
    }
    
    public func transcribe(url: URL) async throws -> String {
        let data = try Data(contentsOf: url)

        let query = AudioTranscriptionQuery(
            file: data,
            fileName: url.lastPathComponent,
            model: .whisper_1,
            language: language
        )

        let result = try await openAI.audioTranscriptions(query: query)
        return result.text
    }
}
