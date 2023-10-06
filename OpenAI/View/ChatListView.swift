//
//  ChatListView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/06.
//

import SwiftUI

struct ChatListView: View {
    var isBotChatView = false
    @EnvironmentObject var appData: AppData
    @ObservedObject var chatViewModel: ChatViewModel

    var body: some View {
        VStack {
            searchFieldView
            scrollView
        }
    }

    private var searchFieldView: some View {
        Group {
            if chatViewModel.isActiveChatSearch {
                SearchFieldView(
                    currentPage: $chatViewModel.currentPage,
                    searchText: $chatViewModel.searchText
                )
                .transition(.move(edge: .top))
                .animation(.easeInOut(duration: 0.3))
            }
            if isBotChatView {
                SearchFieldView(
                    currentPage: $chatViewModel.currentPage,
                    searchText: $chatViewModel.searchText
                )
            }
        }
    }

    private var scrollView: some View {
        ScrollViewReader { scrollViewProxy in
            List {
                ForEach(chatViewModel.chats.indices, id: \.self) { index in
                    chatRow(at: index)
                        .padding(.horizontal, 15)
                        .background(GeometryReader { _ in
                            onRowAppear(at: index)
                        })
                }
                .onDelete(perform: deleteChat)
            }
            .onAppear {
                chatViewModel.scrollViewProxy = scrollViewProxy
                handleOnAppear()
            }
        }
    }

    private func handleOnAppear() {
        if chatViewModel.chats.isEmpty {
            chatViewModel.chats = []
            chatViewModel.currentPage = 1
        }
    }
    
    private func deleteChat(at offsets: IndexSet) {
        offsets.forEach { index in
            let chatToDelete = chatViewModel.chats[index]
            chatViewModel.deleteChat(chatToDelete)
        }
        chatViewModel.chats.remove(atOffsets: offsets)
    }

    private func chatRow(at index: Int) -> some View {
        var chat = chatViewModel.chats[index]
        return NavigationLink(
            destination: MessagesView(chat: chat, enableSpeech: appData.isVoiceOutputEnabled),
            label: {
                HStack {
                    chat.botProfileImage
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                    Text(chat.title)
                    Spacer()
                }
                .foregroundColor(Color.primary)
                .padding(.vertical, 20)
                .font(.headline)
            }
        )
    }

    private func onRowAppear(at index: Int) -> some View {
        VStack {}.onAppear {
            handleScrollEnd(at: index)
        }
    }

    private func handleScrollEnd(at index: Int) {
        if index == chatViewModel.chats.count - 1 {
            chatViewModel.currentPage += 1
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatListView(chatViewModel: ChatViewModel())
                .environmentObject(AppData())
                .previewDisplayName("Light Mode")

            ChatListView(chatViewModel: ChatViewModel()).colorScheme(.dark)
                .environmentObject(AppData())
                .previewDisplayName("Dark Mode")
        }
    }
}
