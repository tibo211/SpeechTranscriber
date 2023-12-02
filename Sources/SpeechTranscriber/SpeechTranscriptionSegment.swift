//
//  SpeechTranscriptionSegment.swift
//
//
//  Created by Tibor Felföldy on 2023-12-02.
//

import Foundation

public struct SpeechTranscriptionSegment {
    public let substring: String
    public let time: ClosedRange<TimeInterval>
}
