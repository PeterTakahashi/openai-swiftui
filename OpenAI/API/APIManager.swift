//
//  APIManager.swift
//  OpenAI
//
//  Created by Apple on 2023/04/27.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    private init() {}
    
    func postUserFavoriteBot(botID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
          let url = URL(string: backendDomain + "/user_favorite_bots")!
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")

          let params: [String: Any] = ["user_favorite_bot": ["bot_id": botID]]
          request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

          guard let token = UserDefaultsManager.shared.userToken else {
            print("Token not found")
            completion(.failure(NSError(domain: "TokenNotFound", code: 401, userInfo: nil)))
            return
          }

          request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
          performRequest(request: request, completion: completion)
      }

      func destroyUserFavorite(botID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
          let url = URL(string: backendDomain + "/user_favorite_bots/\(botID)")!
          var request = URLRequest(url: url)
          request.httpMethod = "DELETE"

          guard let token = UserDefaultsManager.shared.userToken else {
              print("Token not found")
              completion(.failure(NSError(domain: "TokenNotFound", code: 401, userInfo: nil)))
              return
          }

          request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
          performRequest(request: request, completion: completion)
      }

      private func performRequest(request: URLRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                  completion(.failure(error))
                  return
              }
              if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                  completion(.success(true))
              } else {
                  completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
              }
          }
          task.resume()
      }
}
