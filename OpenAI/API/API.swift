//
//  API.swift
//  OpenAI
//
//  Created by Apple on 2023/04/08.
//

import Foundation

class API {
    private func performRequest<T: Decodable>(method: String, url: URL, parameters: [String: Any]? = nil, requireToken: Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        
        if requireToken {
            guard let token = UserDefaultsManager.shared.userToken else {
                print("Token not found")
                completion(.failure(NSError(domain: "TokenNotFound", code: 401, userInfo: nil)))
                return
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let parameters = parameters, let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            request.httpBody = httpBody
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                return
            }

            if httpResponse.statusCode == 422 {
                UserDefaultsManager.shared.userToken = nil
                completion(.failure(NSError(domain: "AuthorizationError", code: 422, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func sendAuthRequest(idToken: String, languageCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(backendDomain)/auth/apple") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success("User authenticated successfully."))
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
            }
        }
        task.resume()
    }
}
