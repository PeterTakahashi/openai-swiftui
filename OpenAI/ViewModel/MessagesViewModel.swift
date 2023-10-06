//
//  MessagesViewModel.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

class MessagesViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @Published var enableSpeech = false
    @Published var isPlaying: Bool = false
    @Published var suggests: [String] = []
    @Published var isTextFieldFocused: Bool = false
    @Published var title: String = ""
    private let speechService = SpeechService.shared
    private let suggestStrings = [
        "What do you do?",
        "Why were you created?",
        "What is your favorite food?",
        "Tell me about space.",
        "Tell me something about artificial intelligence.",
        "Tell me about the history of Japan.",
        "What is the highest mountain?",
        "Teach me a phrase in French.",
        "Do robots have emotions?",
        "Tell me about the latest advancements in science and technology.",
        "Can you create a poem?",
        "Tell me about [a celebrity/historical figure].",
        "What is the weather like today?",
        "Tell me about mysterious phenomena around the world.",
        "Tell me about the culture of [a specific region/country].",
        "Can you recommend a book?",
        "What is an interesting fact about animals or plants?",
        "Tell me something about a famous scientist.",
        "What is a question you can't answer?",
        "Teach me basic computer operations."
    ]
    
    var chatgptApi: ChatGPTAPI = ChatGPTAPI()
    let api: API = API()
    
    init(enableSpeech: Bool = false) {
        self.enableSpeech = enableSpeech
        self.setup()
    }
    
    func setup() {
        self.chatgptApi.systemMessage = Message(role: "system", content: "you are helpful assistant")
        setSuggests()
    }

    func setSuggests() {
        self.suggests = Array(suggestStrings.shuffled().prefix(4))
    }
    
    @MainActor
    func sendTapped() async {
        await send(text: inputMessage)
    }
    
    @MainActor
    func clearMessages() {
        stopSpeaking()
        chatgptApi.deleteHistoryList()
        setSuggests()
        withAnimation { [weak self] in
            self?.messages = []
            self?.inputMessage = ""
            self?.isInteractingWithChatGPT = false
            self?.isPlaying = false
        }
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.text)
    }
    
    @MainActor
    private func send(text: String) async {
            isInteractingWithChatGPT = true
            var streamText = ""
            var messageRow = MessageRow(
                id: (self.messages.last?.id ?? 0) + 1,
                isInteractingWithChatGPT: true,
                sendImage: "profile",
                text: text,
                responseImage: "ai",
                replyText: streamText)
            
            self.messages.append(messageRow)
            inputMessage = ""
            
            do {
                let stream = try await chatgptApi.sendMessageStream(text: text)
                for try await text in stream {
                    streamText += text
                    messageRow.replyText = streamText.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.messages[self.messages.count - 1] = messageRow
                }
            } catch {
                messageRow.responseError = error.localizedDescription
            }
            inputMessage = ""
            messageRow.isInteractingWithChatGPT = false
            self.messages[self.messages.count - 1] = messageRow
            isInteractingWithChatGPT = false
            speakLastResponse()
    }

    func speakLastResponse() {
        if (!enableSpeech) { return }

        guard let replyText = self.messages.last?.replyText, !replyText.isEmpty else {
            return
        }
 
        stopSpeaking()
        self.isPlaying = true
        print(self.isPlaying)
        speechService.speak(text: replyText) { [weak self] in
            self?.stopSpeaking()
        }
    }

    func stopSpeaking() {
        speechService.stopSpeaking()
        self.isPlaying = false
    }
}
