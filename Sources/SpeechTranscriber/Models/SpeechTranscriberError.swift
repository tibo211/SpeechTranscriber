//
//  SpeechTranscriberError.swift
//
//
//  Created by Tibor Felföldy on 2023-12-03.
//

import Foundation

public enum SpeechTranscriberError: Error {
    case failedToCreateRecognizer
    case recognizerIsNotAvailable
}
