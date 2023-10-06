//
//  MessageRow.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

struct MessageRow: Codable, Identifiable {
    var id: Int?
    var isInteractingWithChatGPT: Bool = false
    var sendImage: String = ""
    var text: String
    var responseImage: String = ""
    var replyText: String?
    var isGood: Bool = false
    var isBad: Bool = false
    var createdAt: Date?
    var updatedAt: Date?
    var responseError: String?
    var isPlaying: Bool
    var chatId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        // case isInteractingWithChatGPT = "is_interacting_with_chat_gpt"
        // case sendImage = "send_image"
        case text
       // case responseImage = "response_image"
        case replyText = "reply_text"
        case isGood = "is_good"
        case isBad = "is_bad"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
       // case responseError = "response_error"
        //case isPlaying = "is_playing"
        case chatId = "chat_id"
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        isInteractingWithChatGPT = false
        sendImage = "profile"
        text = try container.decode(String.self, forKey: .text)
        responseImage = "ai"
        replyText = try container.decodeIfPresent(String.self, forKey: .replyText)
        isGood = try container.decodeIfPresent(Bool.self, forKey: .isGood) ?? false
        isBad = try container.decodeIfPresent(Bool.self, forKey: .isBad) ?? false
        createdAt = try MessageRow.dateFormatter.date(from: container.decode(String.self, forKey: .createdAt)) ?? Date()
        updatedAt = try MessageRow.dateFormatter.date(from: container.decode(String.self, forKey: .updatedAt)) ?? Date()
        responseError = nil
        isPlaying = false
        chatId = try container.decodeIfPresent(Int.self, forKey: .chatId)
    }

    init() {
        self.id = 0
        self.text = ""
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isPlaying = false
        self.chatId = nil
    }
    
    init(
        id: Int? = nil,
        isInteractingWithChatGPT: Bool,
         sendImage: String,
         text: String,
         responseImage: String,
         replyText: String,
        responseError: String? = nil
    ) {
        self.id = id
        self.isInteractingWithChatGPT = isInteractingWithChatGPT
        self.sendImage = sendImage
        self.text = text
        self.responseImage = responseImage
        self.replyText = replyText
        self.createdAt = nil
        self.updatedAt = nil
        self.isPlaying = false
        self.responseError = responseError
        self.chatId = nil
    }
}
