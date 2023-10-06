//
//  UserData.swift
//  OpenAI
//
//  Created by Apple on 2023/04/28.
//

import Foundation
import SwiftUI
import Combine

class UserData: ObservableObject {
    var api: API = API()
    @Published var user: User?

    func fetchUser() {
        api.fetchUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print("Error fetch uesr: \(error)")
                }
            }
        }
    }
}
