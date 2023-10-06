//
//  TokenView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/06.
//
import SwiftUI
import GoogleMobileAds

struct TokenView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var reward: Reward
    @State var showModal: Bool = false

    var body: some View {
        Button(action: {
            showModal.toggle()
            if (self.reward.rewardLoaded == false) {
                self.reward.LoadReward()
            }
        }) {
            HStack(spacing: 4) {
                Image("coin")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(formatToken(userData.user?.token ?? 0))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }.sheet(isPresented: $showModal) {
            TokenModalView(showModal: $showModal)
        }.onAppear {
            self.userData.fetchUser()
        }
    }
    
    func formatToken(_ token: Int) -> String {
           let units: [(threshold: Int, divider: Double, suffix: String)] = [
               (1_000_000_000_000, 1_000_000_000_000.0, "T"),
               (1_000_000_000, 1_000_000_000.0, "G"),
               (1_000_000, 1_000_000.0, "M"),
               (1_000, 1_000.0, "k")
           ]
           
           for (threshold, divider, suffix) in units {
               if token >= threshold {
                   return String(format: "%.1f%@", Double(token) / divider, suffix)
               }
           }
           return String(token)
       }
}

struct TokenView_Previews: PreviewProvider {
    
    static var previews: some View {
        TokenView().environmentObject(UserData()).environmentObject(Reward())
    }
}
