//
//  ChatViewModel.swift
//  OpenAI
//
//  Created by Apple on 2023/04/17.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    let api: API = API()
    var bot: Bot?
    var scrollViewProxy: ScrollViewProxy?
    @Published var isActiveChatSearch = false
    @Published var searchText: String = ""
    @Published var chats: [Chat] = []
    @Published var currentPage: Int = 1 {
        didSet {
            api.fetchChats(currentPage: currentPage, searchText: searchText, botId: bot?.id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedChats):
                        if self?.currentPage == 1 {
                            self?.chats = fetchedChats
                        } else {
                            self?.chats.append(contentsOf: fetchedChats)
                        }
                    case .failure(let error):
                        print("Error fetching chats: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func deleteChat(_ chat: Chat) {
        guard let url = URL(string: "\(backendDomain)/chats/\(chat.id)") else {
            return
        }
        
        guard let token = UserDefaultsManager.shared.userToken else {
            print("Token not found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 204 {
                        DispatchQueue.main.async {
                            if let index = self.chats.firstIndex(where: { $0.id == chat.id }) {
                                self.chats.remove(at: index)
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    func setBotByBotId(botId: Int) {
        api.getBot(botId: botId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedBot):
                    self?.bot = fetchedBot
                case .failure(let error):
                    print("Error fetching bot: \(error.localizedDescription)")
                }
            }
        }
    }
}

