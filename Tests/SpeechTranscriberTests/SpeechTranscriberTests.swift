import XCTest
@testable import SpeechTranscriber

final class SpeechTranscriberTests: XCTestCase {
    let url = Bundle.module.url(forResource: "transcribing",
                                withExtension: "mp3")!
    
    func testOnDeviceSpeechTranscriber() async throws {
        let transcriber = try OnDeviceSpeechTranscriber()

        let result = try await transcriber.transcribe(url: url)
        
        print("""
              
              ------
              On device recognition result:
              \(result)
              ------
              """)
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testWhisper() async throws {
        let apiKey = ""
        
        if apiKey.isEmpty {
            print("Set an API key to run the test")
            return
        }
        
        let transcriber = WhisperSpeechTranscriber(apiToken: apiKey)

        let result = try await transcriber.transcribe(url: url)

        print("""
              
              ------
              Whisper recognition result:
              \(result)
              ------
              """)

        XCTAssertFalse(result.isEmpty)
    }
}
