//
//  BotListViewModel.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import Foundation
import SwiftUI
import Combine

class BotListViewModel: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let selectedLanguageCodeKey = "selectedLanguageCode"
    @Published var bots: [Bot] = []
    @Published var currentPage: Int = 1 {
        didSet {
            fetchBots()
        }
    }
    @Published var searchText: String = ""
    @Published var scrollViewProxy: ScrollViewProxy?
    @Published var isCreatedBot: Bool = false
    @Published var isShowFavoritesOnly = false {
        didSet {
            self.currentPage = 1
        }
    }

    private var api = API()

    init() {
        fetchBots()
    }
    
    func fetchBots() {
        api.fetchBots(currentPage: currentPage, searchText: searchText, languageCode: userDefaults.string(forKey: selectedLanguageCodeKey) ?? "en-US", isFavoriteOnly: isShowFavoritesOnly) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedBots):
                    if self?.currentPage == 1 {
                        self?.bots = fetchedBots
                    } else {
                        self?.bots.append(contentsOf: fetchedBots)
                    }
                case .failure(let error):
                    print("Error fetching chats: \(error.localizedDescription)")
                }
            }
        }
    }
}

