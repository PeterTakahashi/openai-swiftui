//
//  ContentView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        VStack {
            if (appData.isLoggedIn) {
                if (appData.openAIApiKey.count == 0) {
                    ApiKeyInputView()
                } else {
                    MessagesView(enableSpeech: appData.isVoiceOutputEnabled)
                }
            } else {
                SigninView()
            }
        }
    }

    private func signOut() {
        UserDefaultsManager.shared.userToken = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(AppData())
                .previewDisplayName("Light Mode")
            ContentView().environmentObject(AppData()).colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
