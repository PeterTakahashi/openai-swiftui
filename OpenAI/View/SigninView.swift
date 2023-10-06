//
//  SigninView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI
import AuthenticationServices

struct SigninView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            VStack {
                Text(appName)
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 200)
                VStack {
                    SignInWithAppleButton { result in
                        switch result {
                        case .success(let authorization):
                            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                               let identityTokenData = appleIDCredential.identityToken,
                               let identityToken = String(data: identityTokenData, encoding: .utf8) {

                                appData.api.sendAuthRequest(idToken: identityToken, languageCode: appData.selectedLanguageCode) { result in
                                    switch result {
                                    case .success(_):
                                        DispatchQueue.main.async {
                                            self.appData.isLoggedIn = true
                                            UserDefaultsManager.shared.userToken = identityToken
                                        }
                                    case .failure(let error):
                                        DispatchQueue.main.async {
                                            self.appData.alertTitle = "Error"
                                            self.appData.alertMessage = "Authentication failed: \(error.localizedDescription)"
                                            self.appData.isAlertPresented = true
                                            UserDefaultsManager.shared.userToken = nil
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.appData.alertTitle = "Error"
                                    self.appData.alertMessage = "Failed to retrieve identity token."
                                    self.appData.isAlertPresented = true
                                    UserDefaultsManager.shared.userToken = nil
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.appData.alertTitle = "Error"
                                self.appData.alertMessage = "Sign in with Apple failed: \(error.localizedDescription)"
                                self.appData.isAlertPresented = true
                                UserDefaultsManager.shared.userToken = nil
                            }
                        }
                    }
                    .frame(width: 280, height: 45)
                    .alert(isPresented: self.$appData.isAlertPresented) {
                        Alert(title: Text(self.appData.alertTitle),
                              message: Text(self.appData.alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                }
                Button(action: {
                    self.appData.isLoggedIn = true
                    UserDefaultsManager.shared.userToken = "test"
                }) {
                            Text("Skip login")
                }.padding(.top)
            }
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SigninView().environmentObject(AppData())
                .previewDisplayName("Light Mode")
            
            SigninView().environmentObject(AppData()).colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
