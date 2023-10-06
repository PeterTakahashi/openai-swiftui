//
//  MessageSuggestsView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/08.
//

import SwiftUI

struct MessageSuggestsView: View {
    var chatId: Int
    @Binding var inputMessage: String
    @ObservedObject var messageSuggestsViewModel: MessageSuggestsViewModel
       
    init(chatId: Int, inputMessage: Binding<String>) {
        self.chatId = chatId
        self._inputMessage = inputMessage
        self.messageSuggestsViewModel = MessageSuggestsViewModel(chatId: chatId)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(self.messageSuggestsViewModel.suggests, id: \.self) { suggest in
                    Button(action: {
                        inputMessage = suggest
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
}

struct MessageSuggestsView_Previews: PreviewProvider {
    static var previews: some View {
        MessageSuggestsView(chatId: 1, inputMessage: .constant(""))
    }
}
