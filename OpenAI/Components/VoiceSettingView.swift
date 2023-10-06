//
//  VoiceSettingView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/05.
//

import SwiftUI

struct VoiceSettingView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        VStack {
            HStack {
                Image(systemName: appData.isVoiceOutputEnabled ? "speaker.wave.3.fill" : "speaker.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    Text("Auto Voice Output")
                    Spacer()
                Toggle(isOn: $appData.isVoiceOutputEnabled) {
                    Text("")
                }
            }
        }.padding(0)
    }
}

struct VoiceSettingView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceSettingView().environmentObject(AppData())
    }
}
