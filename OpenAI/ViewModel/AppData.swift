//
//  AppData.swift
//  OpenAI
//
//  Created by Apple on 2023/04/03.
//

import Foundation
import SwiftUI
import Combine

class AppData: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let isVoiceOutputEnabledKey = "isVoiceOutputEnabled"
    private let selectedLanguageCodeKey = "selectedLanguageCode"
    private let openAIApiKeyKey = "openAIApiKey"
    var api = API()
    
    init() {
        // Load saved value of isVoiceOutputEnabled
        self.isVoiceOutputEnabled = userDefaults.bool(forKey: isVoiceOutputEnabledKey)
        self.selectedLanguageCode = userDefaults.string(forKey: selectedLanguageCode) ?? "en"
        self.openAIApiKey = userDefaults.string(forKey: openAIApiKeyKey) ?? ""
    }

    @Published var isLoggedIn: Bool = UserDefaultsManager.shared.isLoggedIn()
    @Published var isAlertPresented = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isVoiceOutputEnabled = false {
        didSet {
            userDefaults.set(isVoiceOutputEnabled, forKey: isVoiceOutputEnabledKey)
        }
    }
    @Published var selectedLanguageCode: String = "en" {
        didSet {
            userDefaults.set(selectedLanguageCode, forKey: selectedLanguageCodeKey)
        }
    }
    @Published var openAIApiKey: String = "" {
        didSet {
            userDefaults.set(openAIApiKey, forKey: openAIApiKeyKey)
        }
    }
}
