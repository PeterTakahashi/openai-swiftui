//
//  BotList.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import SwiftUI

struct BotList: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(appData.bots) { bot in
                        NavigationLink {
                            BotDetail(bot: bot)
                        } label: {
                            BotRow(bot: bot)
                        }
                    }
                }
            }
        }
    }
}

struct BotList_Previews: PreviewProvider {
    static var previews: some View {
        BotList().environmentObject(AppData())
    }
}
