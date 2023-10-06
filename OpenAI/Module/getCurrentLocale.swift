//
//  getCurrentLocale.swift
//  OpenAI
//
//  Created by Apple on 2023/04/05.
//

import Foundation

func getCurrentLocaleIdentifier() -> String? {
    guard let languageCode = Locale.current.languageCode, let regionCode = Locale.current.regionCode else {
        return nil
    }
    return "\(languageCode)-\(regionCode)"
}

func getSelectLanguageCode() -> String {
    let userDefaults = UserDefaults.standard
    let selectedLanguageCodeKey = "selectedLanguageCode"

    // Get the selectedLanguageCode from UserDefaults
    if let storedSelectedLanguageCode = userDefaults.string(forKey: selectedLanguageCodeKey) {
        return storedSelectedLanguageCode
    } else {
        return "en"
    }
}
