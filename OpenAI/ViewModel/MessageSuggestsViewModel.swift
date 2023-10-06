//
//  MessageSuggestsViewModel.swift
//  OpenAI
//
//  Created by Apple on 2023/04/25.
//

import Foundation

class MessageSuggestsViewModel: ObservableObject {
    @Published var suggests: [String] = []
    let api: API = API()
    
    init(chatId: Int) {
        getSuggests(chatId: chatId)
    }
    
    func getSuggests(chatId: Int) {
        api.getSuggests(chatId: chatId) { result in
            switch result {
            case .success(let fetchedSuggests):
                DispatchQueue.main.async {
                    self.suggests = fetchedSuggests
                }
            case .failure(let error):
                print("Error fetching suggests: \(error.localizedDescription)")
            }
        }
    }
}
