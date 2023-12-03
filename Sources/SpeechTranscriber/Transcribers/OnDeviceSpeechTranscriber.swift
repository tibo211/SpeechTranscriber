//
//  OnDeviceSpeechTranscriber.swift
//
//
//  Created by Tibor Felföldy on 2023-12-02.
//

import Speech

public final class OnDeviceSpeechTranscriber: SpeechTranscriber {
    public private(set) var speeches: [Speech] = []
    
    public var formattedString: String {
        speeches
            .map(\.formattedString)
            .joined(separator: "\n\n")
    }

    let recognizer: SFSpeechRecognizer

    public init(locale: Locale = .current) throws {
        guard let recognizer = SFSpeechRecognizer(locale: locale) else {
            throw SpeechTranscriberError.failedToCreateRecognizer
        }

        self.recognizer = recognizer
    }

    public func transcribe(url: URL) async throws -> String {
        guard recognizer.isAvailable else {
            throw SpeechTranscriberError.recognizerIsNotAvailable
        }
        
        // Clear last speech results.
        speeches = []

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.requiresOnDeviceRecognition = true
        request.shouldReportPartialResults = true
        if #available(macOS 13, iOS 16, *) {
            request.addsPunctuation = true
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            recognizer.recognitionTask(with: request) { [unowned self] result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result else { return }
                
                // Update speech.
                let transcription = result.bestTranscription
                
                let currentSpeech = Speech(
                    formattedString: transcription.formattedString,
                    segments: transcription.segments.compactMap { segment in
                        let range = Range(segment.substringRange,
                                          in: transcription.formattedString)
                        guard let range else {
                            return nil
                        }
                        return SpeechSegment(
                            substringRange: range,
                            time: segment.timestamp...(segment.timestamp + segment.duration)
                        )
                    }
                )

                if #available(macOS 11.3, iOS 14.5, *) {
                    // If the speechRecognitionMetadata has value that probably means
                    // it has finished the recognition with one speech or one part of a speech.
                    if result.speechRecognitionMetadata != nil {
                        speeches.append(currentSpeech)
                    }
                } else {
                    // On older OS versions there is just a single recognition.
                    speeches = [currentSpeech]
                }
                
                if result.isFinal {
                    continuation.resume(returning: formattedString)
                }
            }
        }
    }
}
