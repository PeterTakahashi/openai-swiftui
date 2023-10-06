//
//  BotRow.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import SwiftUI

struct BotRow: View {
    @ObservedObject var bot: Bot

    var body: some View {
        HStack {
            bot.image
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            VStack(alignment: .leading) {
                Text(bot.name)
                Text(bot.category).foregroundColor(.gray).font(.caption)
            }
            Spacer()
            if bot.is_favorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct BotRow_Previews: PreviewProvider {
    static let botListViewModel = BotListViewModel()
    static let bots = botListViewModel.bots

    static var previews: some View {
        Group {
            BotRow(bot: bots[0])
            BotRow(bot: bots[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
