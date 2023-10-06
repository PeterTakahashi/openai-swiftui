//
//  SettingMenuView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

struct InfoButton: View {
    let urlString: String
    let label: String
    let imageSystemName: String

    var body: some View {
        Button(action: {
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        }) {
            HStack {
                Image(systemName: imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(label)
                Spacer()
            }
        }
    }
}

struct SettingMenuView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        VStack {
            settingList
        }
    }

    private var settingList: some View {
        List {
            languageSection
            resetOpenAIApyKeyButton
            infoSection
            signOutButton
        }
        .foregroundColor(Color.primary)
        .background(Color(.systemBackground))
    }

    private var languageSection: some View {
        Section {
            VoiceSettingView()
            languagePicker
        } header: {
            Text("Select")
        }
    }
    
    private var resetOpenAIApyKeyButton: some View {
        Button(action: {
            appData.openAIApiKey = ""
        }) {
            HStack {
                Image(systemName: "xmark.circle")
                Text("Reset OpenAI Api key")
                Spacer()
            }
        }
    }

    private var languagePicker: some View {
        HStack {
            Image(systemName: "network")
            Spacer()
            Picker("Voice Language", selection: self.$appData.selectedLanguageCode) {
                ForEach(languages, id: \.code) { language in
                    Text(language.name).foregroundColor(.primary).tag(language.code)
                }
            }.foregroundColor(.primary)
        }
    }

    private var infoSection: some View {
        Section {
            InfoButton(urlString: "https://voostlab.co/OpenAI/privacy", label: "Privacy Policy", imageSystemName: "doc.text.fill")
        } header: {
            Text("Infomation")
        }
    }

    private var signOutButton: some View {
        Button(action: {
            self.appData.isLoggedIn = false
            UserDefaultsManager.shared.userToken = nil
        }) {
            HStack {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("Sign Out")
                Spacer()
            }
        }
    }
}

struct SettingMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingMenuView().environmentObject(AppData())
                .previewDisplayName("Light Mode")
            SettingMenuView().environmentObject(AppData()).colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
