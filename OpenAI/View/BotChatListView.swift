//
//  BotChatListView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/23.
//

import SwiftUI

struct BotChatListView: View {
    var bot: Bot
    @EnvironmentObject var appData: AppData
    @ObservedObject var chatViewModel: ChatViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ChatListView(isBotChatView: true, chatViewModel: chatViewModel)
            addButton
        }
    }
    
    private var addButton: some View {
        NavigationLink(
            destination: MessagesView(enableSpeech: appData.isVoiceOutputEnabled),
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
}

struct BotChatListView_Previews: PreviewProvider {
    static let botListViewModel = BotListViewModel()
    static let bots = botListViewModel.bots

    static var previews: some View {
        BotChatListView(bot: bots[0], chatViewModel: ChatViewModel())
    }
}
