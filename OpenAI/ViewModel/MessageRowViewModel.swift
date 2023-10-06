//
//  MessageRowViewModel.swift
//  OpenAI
//
//  Created by Apple on 2023/04/05.
//
import Combine
import SwiftUI

class MessageRowViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var message: MessageRow
    let responseImage: String
    private let speechService: SpeechService = SpeechService.shared
    
    init(message: MessageRow, responseImage: String) {
        self.message = message
        self.responseImage = responseImage
    }
    
    func startSpeaking() {
        guard let replyText = message.replyText, !replyText.isEmpty else { return }
        
        isPlaying = true
        speechService.speak(text: replyText) {
                DispatchQueue.main.async {
                    self.isPlaying = false
                }
        }
    }
    
    func stopSpeaking() {
        speechService.stopSpeaking()
        isPlaying = false
    }
    
    func updateMessage(isGood: Bool, isBad: Bool) {
        message.isGood = isGood
        message.isBad = isBad
    }
}
