import XCTest
@testable import SpeechTranscriber

final class SpeechTranscriberTests: XCTestCase {
    func testOnDeviceSpeechTranscriber() async throws {
        let transcriber = try OnDeviceSpeechTranscriber()
        guard let url = Bundle.module.url(forResource: "transcribing", withExtension: "mp3") else {
            fatalError("failed to load audio")
        }

        let result = try await transcriber.transcribe(url: url)
        
        XCTAssertFalse(result.isEmpty)
        print(result)
    }
}
