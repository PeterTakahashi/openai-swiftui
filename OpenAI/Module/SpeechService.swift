import UIKit
import AVFoundation

class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    static let shared = SpeechService()
    private(set) var busy: Bool = false
    
    private var synthesizer: AVSpeechSynthesizer?
    private var completionHandler: (() -> Void)?
    
    func speak(text: String, completion: @escaping () -> Void) {
        guard !self.busy else {
            print("Speech Service busy!")
            return
        }
        self.busy = true
        
        DispatchQueue.main.async {
            self.completionHandler = completion
            self.synthesizer = AVSpeechSynthesizer()
            self.synthesizer?.delegate = self
            
            let utterance = AVSpeechUtterance(string: text)
            // TODO: fix language
            utterance.voice = AVSpeechSynthesisVoice(language: "en")
            
            self.synthesizer!.speak(utterance)
        }
    }
    
    // Implement AVSpeechSynthesizerDelegate "did finish" callback to cleanup and notify listener of completion.
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.synthesizer?.delegate = nil
        self.synthesizer = nil
        self.busy = false
        
        self.completionHandler!()
        self.completionHandler = nil
    }
    
    func stopSpeaking() {
        guard let synthesizer = synthesizer, synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer(synthesizer, didFinish: AVSpeechUtterance(string: ""))
    }
}
