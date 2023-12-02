//
//  OnDeviceSpeechTranscriber.swift
//
//
//  Created by Tibor Felföldy on 2023-12-02.
//

import Speech

public final class OnDeviceSpeechTranscriber: SpeechTranscriber {
    public private(set) var segments: [SpeechTranscriptionSegment] = []

    let recognizer: SFSpeechRecognizer

    public init?(locale: Locale = .autoupdatingCurrent) {
        guard let recognizer = SFSpeechRecognizer(locale: locale) else {
            return nil
        }

        self.recognizer = recognizer
    }

    public func transcribe(url: URL) async throws -> String {
        guard recognizer.isAvailable else { fatalError("throw error here") }

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.requiresOnDeviceRecognition = true

        return try await withCheckedThrowingContinuation { continuation in
            recognizer.recognitionTask(with: request) { [unowned self] result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result else { return }
                
                // Update segments.
                segments = result.bestTranscription.segments.map { segment in
                    SpeechTranscriptionSegment(
                        substring: segment.substring,
                        time: segment.timestamp...(segment.timestamp + segment.duration)
                    )
                }
                
                if result.isFinal {
                    continuation.resume(returning: result.bestTranscription.formattedString)
                }
            }
        }
    }
}
