//
//  ChatView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appData: AppData
    @ObservedObject var chatViewModel: ChatViewModel

    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing) {
                ChatListView(isBotChatView: false, chatViewModel: chatViewModel)
                    .padding(.top, 60)
                addButton
            }
            topBar
        }
    }
    
    private var addButton: some View {
        NavigationLink(
            destination: MessagesView(chat: Chat(id: 0, botId: appData.currentBotId), enableSpeech: appData.isVoiceOutputEnabled),
            label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 65)
                    .foregroundColor(.gray)
                    .padding(20)
                    .shadow(radius: 3)
            }
        )
    }
    
    private var topBar: some View {
        HStack {
            appNameButton
            Spacer()
            searchButton
            TokenView().padding(.trailing)
        }
        .padding(.bottom)
        .background(Color(.systemBackground))
    }
    
    private var appNameButton: some View {
        Button(action: {
            withAnimation {
                chatViewModel.scrollViewProxy?.scrollTo(0)
            }
            chatViewModel.currentPage = 1
        }) {
            HStack {
                Text(appName)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }.padding(.leading)
        }
    }
    
    private var searchButton: some View {
        Button(action: {
            self.chatViewModel.isActiveChatSearch.toggle()
        }) {
            Image(systemName: "magnifyingglass")
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .foregroundColor(.secondary)
                .clipShape(Circle())
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatView(chatViewModel: ChatViewModel())
                .environmentObject(AppData())
                .environmentObject(Reward())
                .previewDisplayName("Light Mode")
            
            ChatView(chatViewModel: ChatViewModel())
                .environmentObject(AppData())
                .environmentObject(Reward())
                .colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
