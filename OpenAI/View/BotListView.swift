//
//  BotListView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import SwiftUI

struct BotListView: View {
    @ObservedObject var botListViewModel: BotListViewModel

    var body: some View {
            VStack {
                SearchFieldView(currentPage: $botListViewModel.currentPage, searchText: $botListViewModel.searchText)
                ScrollViewReader { scrollViewProxy in
                    List {
                        Section {
                            Toggle(isOn: $botListViewModel.isShowFavoritesOnly) {
                                Text("Favorites only")
                            }
                        }
                        ForEach(botListViewModel.bots.indices, id: \.self) { index in
                            VStack {
                                botRow(at: index)
                                    .id(botListViewModel.bots[index].id)
                            }
                            .padding(.horizontal, 15)
                            .background(GeometryReader { innerProxy in
                                VStack {}.onAppear {
                                    handleScrollEnd(at: index)
                                }
                            })
                        }
                    }
                    .onAppear(perform: {
                        botListViewModel.scrollViewProxy = scrollViewProxy
                        if (botListViewModel.bots.count == 0 || botListViewModel.isCreatedBot) {
                            botListViewModel.currentPage = 1
                            botListViewModel.isCreatedBot = false
                        }
                    })
                }
            }
    }
    
    private func botRow(at index: Int) -> some View {
        let bot = botListViewModel.bots[index]
        return NavigationLink(destination: BotDetail(bot: bot), label: {
            BotRow(bot: bot)
        })
    }

    private func handleScrollEnd(at index: Int) {
        if index == botListViewModel.bots.count - 1 {
            botListViewModel.currentPage += 1
        }
    }
}

struct BotListView_Previews: PreviewProvider {
    static var previews: some View {
        BotListView(botListViewModel: BotListViewModel())
    }
}
