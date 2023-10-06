//
//  UserDefaultsManager.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userTokenKey = "userToken"

    private init() {}

    var userToken: String? {
        get {
            return UserDefaults.standard.string(forKey: userTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userTokenKey)
        }
    }

    func isLoggedIn() -> Bool {
        return userToken != nil
    }
}
