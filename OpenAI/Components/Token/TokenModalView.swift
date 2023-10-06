//
//  TokenModalView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/15.
//
import SwiftUI

struct TokenModalView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var reward: Reward
    @Binding var showModal: Bool
    // リワード広告の表示
    func showReward() {
        guard let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                     print("😭: ルートビューコントローラが見つかりませんでした")
                     return
        }
           
        guard let ad = self.reward.rewardedAd else {
                 print("😭: rewardedAdがnilです")
                 return
             }
             
             ad.present(fromRootViewController: rootViewController, userDidEarnRewardHandler: {
                 self.userData.api.claimReward() { result in
                     print("報酬を獲得しました")
                     self.userData.fetchUser()
                 }
                 self.reward.rewardLoaded = false
                 self.reward.LoadReward()
             })
    }
    

    var body: some View {
        VStack {
            Button(action: {
                    showModal.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showReward()
                    }
            }) {
                HStack {
                    Image(systemName: "play.circle")
                        .font(.title)
                        .padding(.trailing)
                    Text("Get 1K tokens by watching an advertisement")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(.systemBackground))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(colorScheme == .dark ? LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            .presentationDetents([.medium])
            
//            Divider().padding(.horizontal, 100).padding(.vertical, 50)
//
//            ModalSubscriptionButton() {}
        }
    }
}

struct TokenModalView_Previews: PreviewProvider {
    static var previews: some View {
        TokenModalView(showModal: .constant(false)).environmentObject(UserData()).environmentObject(Reward())
    }
}
