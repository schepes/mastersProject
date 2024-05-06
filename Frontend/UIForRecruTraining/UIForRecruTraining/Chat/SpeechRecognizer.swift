import Speech

class SpeechRecognizer: ObservableObject {
    func transcribeAudio(from url: URL, completion: @escaping (String?) -> Void) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                print("Recognition failed: \(String(describing: error))")
                completion(nil)
                return
            }
            if result.isFinal {
                completion(result.bestTranscription.formattedString)
            }
        }
    }
}
