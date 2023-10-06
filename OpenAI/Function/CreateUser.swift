//
//  CreateUser.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import Foundation

func createUser(userId: String, email: String, fullName: String) {
    guard let url = URL(string: "http://localhost:3000/users") else { return }
    
    let parameters: [String: Any] = [
        "user_id": userId,
        "email": email,
        "full_name": fullName
    ]

    do {
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response JSON: \(json)")
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }.resume()

    } catch {
        print("Error serializing JSON: \(error.localizedDescription)")
    }
}
