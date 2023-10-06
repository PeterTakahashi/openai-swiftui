//
//  User.swift
//  OpenAI
//
//  Created by Apple on 2023/04/08.
//

import Foundation

class User: ObservableObject, Identifiable, Codable {
    let id: Int
    let email: String
    let name: String
    let token: Int
    let languageCode: String
    let isPurchased: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case token
        case languageCode = "language_code"
        case isPurchased = "is_purchased"
    }
}
