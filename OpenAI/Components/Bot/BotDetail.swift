//
//  BotDetail.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import SwiftUI

struct BotDetail: View {
    @EnvironmentObject var appData: AppData
    @StateObject var chatViewModel = ChatViewModel()
    @ObservedObject var bot: Bot

    var body: some View {
        ScrollView {
            CircleImage(image: AnyView(bot.image)).padding(.top)
            VStack {
                VStack(alignment: .center) {
                    HStack {
                        Text(bot.name)
                            .font(.title)
                        FavoriteButton(isSet: $bot.is_favorite)
                    }
                    Text(bot.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                    NavigationLink {
                        BotChatListView(bot: bot, chatViewModel: chatViewModel).navigationBarTitle(bot.name)
                    } label: {
                        Image(systemName: "message.fill")
                            .foregroundColor(Color.gray)
                            .padding()
                            .font(.largeTitle)
                    }
                }
                
                Divider()
                VStack {
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(bot.category).foregroundColor(.secondary)
                        }
                        Divider()
                        HStack {
                            Text("Provider")
                            Spacer()
                            Text(bot.provider).foregroundColor(.secondary)
                        }
                        Divider()
                        HStack {
                            Text("Minimum token consumption")
                            Spacer()
                            Text("\(bot.base_token_consumption)").foregroundColor(.secondary)
                        }
                        Divider()
                        HStack {
                            Text("LLM")
                            Spacer()
                            Text(bot.llm_name).foregroundColor(.secondary)
                        }
                        Divider()
                        HStack {
                            Text("LLM Provider")
                            Spacer()
                            Text(bot.llm_provider).foregroundColor(.secondary)
                        }
                }
                Divider()
            }
            .padding()
        }
        .onAppear {
            chatViewModel.bot = bot
            if (bot.id != appData.currentBotId) {
                appData.currentBotId = bot.id
            }
        }
    }
}

struct BotDetail_Previews: PreviewProvider {
    static let botListViewModel = BotListViewModel()
    static let bots = botListViewModel.bots
    @State static var bot = bots[0]

    static var previews: some View {
        BotDetail(bot: bot).environmentObject(AppData())
    }
}
