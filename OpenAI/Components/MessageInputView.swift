//
//  MessageInputView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/05.
//
import SwiftUI

struct MessageInputView: View {
    @ObservedObject var messagesViewModel: MessagesViewModel
    @StateObject private var audioRecorder = AudioRecorder()
    @FocusState var isTextFieldFocused: Bool
    @State private var initialInputMessage: String = ""

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if (self.messagesViewModel.isPlaying) {
                Button(action: {
                    self.messagesViewModel.stopSpeaking()
                }) {
                    Image(systemName: "pause.circle.fill").font(.system(size: 30)).foregroundColor(.primary)
                }
            } else {
                Button(action: {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    } else {
                        initialInputMessage = messagesViewModel.inputMessage
                        audioRecorder.startRecording()
                    }
                }) {
                    Image(systemName: audioRecorder.isRecording ? "mic.circle.fill" : "mic.circle")
                            .font(.system(size: 30))
                            .foregroundColor(audioRecorder.isRecording ? .primary : .gray)
                }
            }
          
            TextField(NSLocalizedString("Input message", comment: ""), text: $messagesViewModel.inputMessage, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .disabled(messagesViewModel.isInteractingWithChatGPT)
            
            if messagesViewModel.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button(action: {
                    Task {
                        isTextFieldFocused = false
                        if audioRecorder.isRecording {
                            audioRecorder.stopRecording()
                        }
                        await messagesViewModel.sendTapped()
                    }
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }.disabled(messagesViewModel.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .background(Color(.systemBackground))
        .onChange(of: audioRecorder.recognizedText) { newText in
            if !newText.isEmpty {
                messagesViewModel.inputMessage = initialInputMessage + newText
            }
        }
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageInputView(messagesViewModel: MessagesViewModel(enableSpeech: false))
                .previewDisplayName("Light Mode")
            MessageInputView(messagesViewModel: MessagesViewModel(enableSpeech: false)).colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
