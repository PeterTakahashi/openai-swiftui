//
//  Bot.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import Foundation
import SwiftUI
import CoreLocation
import URLImage

class Bot: ObservableObject, Identifiable, Codable {
    var id: Int
    var name: String
    var category: String
    var provider: String
    var description: String
    var system_prompt: String
    var language_code: String
    var profile_image_url: String
    var llm_name: String
    var llm_provider: String
    var base_token_consumption: Int

    @Published var is_favorite: Bool {
          didSet {
              if (is_favorite) {
                  APIManager.shared.postUserFavoriteBot(botID: id) { result in
                      switch result {
                      case .success(let success):
                          print("Request was successful: \(success)")
                      case .failure(let error):
                          print("Error: \(error)")
                      }
                  }
              } else {
                  APIManager.shared.destroyUserFavorite(botID: id) { result in
                                      switch result {
                                      case .success(let success):
                                          print("Request was successful: \(success)")
                                      case .failure(let error):
                                          print("Error: \(error)")
                                      }
                                  }
              }
          }
      }
    var created_at: String
    var updated_at: String

    @ViewBuilder
    var image: some View {
        if let url = URL(string: profile_image_url), !profile_image_url.isEmpty {
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
    
    init(id: Int, name: String, category: String, provider: String, description: String, system_prompt: String, language_code: String, profile_image_url: String, llm_name: String, llm_provider: String, base_token_consumption: Int, is_favorite: Bool, created_at: String, updated_at: String) {
            self.id = id
            self.name = name
            self.category = category
            self.provider = provider
            self.description = description
            self.system_prompt = system_prompt
            self.language_code = language_code
            self.profile_image_url = profile_image_url
            self.llm_name = llm_name
            self.llm_provider = llm_provider
            self.base_token_consumption = base_token_consumption
            self.is_favorite = is_favorite
            self.created_at = created_at
            self.updated_at = updated_at
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, provider, description, system_prompt, language_code, profile_image_url, llm_name, llm_provider, base_token_consumption, is_favorite, created_at, updated_at
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        provider = try container.decode(String.self, forKey: .provider)
        description = try container.decode(String.self, forKey: .description)
        system_prompt = try container.decode(String.self, forKey: .system_prompt)
        language_code = try container.decode(String.self, forKey: .language_code)
        profile_image_url = try container.decode(String.self, forKey: .profile_image_url)
        llm_name = try container.decode(String.self, forKey: .llm_name)
        llm_provider = try container.decode(String.self, forKey: .llm_provider)
        base_token_consumption = try container.decode(Int.self, forKey: .base_token_consumption)
        is_favorite = try container.decode(Bool.self, forKey: .is_favorite)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(provider, forKey: .provider)
        try container.encode(description, forKey: .description)
        try container.encode(system_prompt, forKey: .system_prompt)
        try container.encode(language_code, forKey: .language_code)
        try container.encode(profile_image_url, forKey: .profile_image_url)
        try container.encode(llm_name, forKey: .llm_name)
        try container.encode(llm_provider, forKey: .llm_provider)
        try container.encode(base_token_consumption, forKey: .base_token_consumption)
        try container.encode(is_favorite, forKey: .is_favorite)
        try container.encode(created_at, forKey: .created_at)
        try container.encode(updated_at, forKey: .updated_at)
    }
}
