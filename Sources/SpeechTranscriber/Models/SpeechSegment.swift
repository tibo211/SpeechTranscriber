//
//  SpeechTranscriptionSegment.swift
//
//
//  Created by Tibor Felföldy on 2023-12-02.
//

import Foundation

public struct SpeechSegment {
    public let substringRange: Range<String.Index>
    public let time: ClosedRange<TimeInterval>
}
