//
//  MessageRowView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

struct MessageRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: MessageRowViewModel
    let retryCallback: (MessageRow) -> Void
    
    var imageSize: CGSize {
        CGSize(width: 25, height: 25)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            userMessageRow
            if let text = viewModel.message.replyText {
                Divider()
                botMessageRow(text: text)
                Divider()
            }
        }
    }
    
    private var userMessageRow: some View {
        messageRow(text: viewModel.message.text,
                   bgColor: userMessageBackgroundColor)
    }
    
    private func botMessageRow(text: String) -> some View {
        messageRow(text: text,
                   bgColor: botMessageBackgroundColor,
                   responseError: viewModel.message.responseError,
                   showDotLoading: viewModel.message.isInteractingWithChatGPT,
                   isBot: true)
    }
    
    private func messageRow(text: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false, isBot: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 24) {
            messageRowContent(text: text, responseError: responseError, showDotLoading: showDotLoading, isBot: isBot)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
    }
      
    private func messageRowContent(text: String, responseError: String? = nil, showDotLoading: Bool = false, isBot: Bool = false) -> some View {
        Group {
            Image(isBot ? "ai" : "profile")
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                if !text.isEmpty {
                    Text(text)
                        .multilineTextAlignment(.leading)
                }
                
                if let error = responseError {
                    responseErrorView(error: error)
                }
                
                if showDotLoading {
                    DotLoadingView()
                        .frame(width: 60, height: 30)
                }
                
                if (!showDotLoading && isBot && (responseError == nil)) {
                    botMessageActions
                }
            }
            .contextMenu(ContextMenu(menuItems: {
                Button("Copy", action: {
                    UIPasteboard.general.string = text
                })
            }))
        }
    }
    
    private func responseErrorView(error: String) -> some View {
        VStack(alignment: .leading) {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
            
            Button("Regenerate response") {
                retryCallback(viewModel.message)
            }
            .foregroundColor(.accentColor)
            .padding(.top)
        }
    }
    
    private var botMessageActions: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.isPlaying ? viewModel.stopSpeaking() : viewModel.startSpeaking()
            }) {
                Image(systemName: "speaker.wave.3.fill")
            }
            .foregroundColor(viewModel.isPlaying ? .primary : .gray)
            .padding(.trailing)
        }.padding(.top)
    }

    private var userMessageBackgroundColor: Color {
        colorScheme == .light ? .white : Color(red: 52 / 255, green: 53 / 255, blue: 65 / 255, opacity: 0.5)
    }

    private var botMessageBackgroundColor: Color {
        colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52 / 255, green: 53 / 255, blue: 65 / 255, opacity: 1)
    }
}

                        

struct MessageRowView_Previews: PreviewProvider {
    static let message = MessageRow(
        id: 1,
        isInteractingWithChatGPT: false,
        sendImage: "profile",
        text: "What is SwiftUI?",
        responseImage: "profile",
        replyText: "SwiftUI is a user interface framework that allows developers to design and develop user interfaces for iOS, macOS, watchOS, and tvOS applications using Swift, a programming language developed by Apple Inc.")
    
    static let message2 = MessageRow(
        id: 2,
        isInteractingWithChatGPT: false, sendImage: "profile",
        text: "What is SwiftUI?",
        responseImage: "profile",
        replyText: "",
        responseError: "ChatGPT is currently not available")
        
    static var previews: some View {
        Group {
            NavigationStack {
                ScrollView {
                    MessageRowView(viewModel: MessageRowViewModel(message: message, responseImage: "ai"), retryCallback: { messageRow in
                        
                    })
                    MessageRowView(viewModel: MessageRowViewModel(message: message2, responseImage: "ai"), retryCallback: { messageRow in
                        
                    })
                      
                }
                .frame(width: 400)
                .previewLayout(.sizeThatFits)
            }.previewDisplayName("Light Mode")
            
            NavigationStack {
                ScrollView {
                    MessageRowView(viewModel: MessageRowViewModel(message: message, responseImage: "ai"), retryCallback: { messageRow in
                        
                    })
                        
                    MessageRowView(viewModel: MessageRowViewModel(message: message2, responseImage: "ai"), retryCallback: { messageRow in
                    })
                      
                }
                .frame(width: 400)
                .previewLayout(.sizeThatFits)
            }.colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
        
    }
}
