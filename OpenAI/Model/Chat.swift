//
//  Chat.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//
import Foundation
import URLImage
import SwiftUI

class Chat: Identifiable, ObservableObject, Codable {
    @Published var id: Int
    @Published var title: String
    let botId: Int
    @Published var botProfileImageUrl: String
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case botId = "bot_id"
        case botProfileImageUrl = "bot_profile_image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        botId = try container.decode(Int.self, forKey: .botId)
        botProfileImageUrl = try container.decode(String.self, forKey: .botProfileImageUrl)
        createdAt = try Chat.dateFormatter.date(from: container.decode(String.self, forKey: .createdAt)) ?? Date()
        updatedAt = try Chat.dateFormatter.date(from: container.decode(String.self, forKey: .updatedAt)) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(botId, forKey: .botId)
        try container.encode(botProfileImageUrl, forKey: .botProfileImageUrl)
        try container.encode(Chat.dateFormatter.string(from: createdAt), forKey: .createdAt)
        try container.encode(Chat.dateFormatter.string(from: updatedAt), forKey: .updatedAt)
    }

    init(id: Int, botId: Int) {
        self.id = id
        self.title = ""
        self.botId = botId
        self.botProfileImageUrl = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    @ViewBuilder
    var botProfileImage: some View {
        if let url = URL(string: botProfileImageUrl), !botProfileImageUrl.isEmpty {
            URLImage(url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        } else {
            // 必要に応じて、画像名を適切なものに変更してください
            Image("ai")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

