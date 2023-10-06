//
//  MessagesView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var messagesViewModel: MessagesViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var isSettingsViewPresented: Bool = false

    init(enableSpeech: Bool) {
        self.messagesViewModel = MessagesViewModel(enableSpeech: enableSpeech)
    }
    
    var body: some View {
        NavigationView(content: {
            messagesView
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle(messagesViewModel.title)
                .navigationBarTitleDisplayMode(.inline)
                .onDisappear {
                    messagesViewModel.stopSpeaking()
                }.navigationBarItems(
                    leading: Button(action: {
                       self.messagesViewModel.clearMessages()
                    }) {
                        Image(systemName: "plus").foregroundColor(.gray)
                    },
                    trailing: Button(action: {
                    self.isSettingsViewPresented.toggle()
                }) {
                    Image(systemName: "gearshape").foregroundColor(.gray)
                }).sheet(isPresented: $isSettingsViewPresented) {
                    SettingMenuView()
                }
        }).onAppear{
            self.messagesViewModel.chatgptApi.openAIApiKey = appData.openAIApiKey
        }
    }

    var messagesView: some View {
        ScrollViewReader { scrollViewProxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(messagesViewModel.messages) { message in
                            MessageRowView(viewModel: MessageRowViewModel(message: message, responseImage: "") ) { message in
                                Task { @MainActor in
                                    await messagesViewModel.retry(message: message)
                                }
                            }.padding(.bottom, messagesViewModel.messages.last?.id == message.id ? 100 : 0).id(message.id)
                        }
                    }
                    .onTapGesture {
                        self.isTextFieldFocused = false
                    }
                }.onTapGesture {
                    self.isTextFieldFocused = false
                }
                if (!self.isTextFieldFocused && !self.messagesViewModel.isInteractingWithChatGPT && self.messagesViewModel.messages.count == 0) {
                    messageSuggestsView()
                }
                MessageInputView(messagesViewModel: messagesViewModel, isTextFieldFocused: self._isTextFieldFocused)
            }
            .onChange(of: messagesViewModel.messages.last?.replyText) { _ in
                scrollToBottom(proxy: scrollViewProxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
    }
    
    func messageSuggestsView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(self.messagesViewModel.suggests, id: \.self) { suggest in
                    Button(action: {
                        self.messagesViewModel.inputMessage = suggest
                    }) {
                        Text(suggest)
                            .padding()
                            .foregroundColor(Color.primary)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                    }
                }
            }.padding(.horizontal)
        }.padding(.bottom, 10).background(.clear)
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = messagesViewModel.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static let messages: [MessageRow] = [
        MessageRow(
            id: 1,
            isInteractingWithChatGPT: false,
            sendImage: "profile",
            text: "What is SwiftUI?",
            responseImage: "profile",
            replyText: "SwiftUI is a user interface framework that allows developers to design and develop user interfaces for iOS, macOS, watchOS, and tvOS applications using Swift, a programming language developed by Apple Inc."),
        MessageRow(
            id: 2,
            isInteractingWithChatGPT: false,
            sendImage: "profile",
            text: "How long does it take to learn SwiftUI?",
            responseImage: "profile",
            replyText: "The amount of time it takes to learn SwiftUI depends on your level of experience with programming and your familiarity with the Swift programming language. However, with dedication and practice, you can learn the basics of SwiftUI in a few weeks."),
        MessageRow(
            id: 3,
            isInteractingWithChatGPT: false,
            sendImage: "profile",
            text: "Can you recommend any resources for learning SwiftUI?",
            responseImage: "profile",
            replyText: "Sure, here are some resources you can use to learn SwiftUI: \n - Apple's official SwiftUI tutorial \n - Hacking with Swift's SwiftUI tutorials \n - SwiftUI by Example by Paul Hudson"),
        MessageRow(
            id: 4,
            isInteractingWithChatGPT: false,
            sendImage: "profile",
            text: "Thanks for the recommendations!",
            responseImage: "profile",
            replyText: "You're welcome! Let me know if you have any other questions."),
        MessageRow(
            id: 5,
            isInteractingWithChatGPT: false,
            sendImage: "profile",
            text: "No problem, thanks again!",
            responseImage: "profile",
            replyText: "You're welcome, happy learning!"),
        MessageRow(
            id: 6,
            isInteractingWithChatGPT: false,
            sendImage: "profile",
            text: "No problem, thanks again!",
            responseImage: "profile",
            replyText: "You're welcome, happy learning!"),
        MessageRow(
            id: 7,
            isInteractingWithChatGPT: true,
            sendImage: "profile",
            text: "No problem, thanks again!",
            responseImage: "profile",
            replyText: "You're welcome, happy learning!"),
    ]
    
    static var previews: some View {
        Group {
            NavigationStack {
                MessagesView(enableSpeech: false)
            }.previewDisplayName("Light Mode").environmentObject(AppData())
            
            NavigationStack {
                MessagesView(enableSpeech: false)
            }.colorScheme(.dark)
                .previewDisplayName("Dark Mode").environmentObject(AppData())
        }
        
    }
}
