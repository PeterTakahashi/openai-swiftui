//
//  OpenAIApp.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

@main
struct MainApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppData())
        }
    }
}
