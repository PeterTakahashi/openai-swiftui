//
//  SubscriptionButtonView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/07.
//

import SwiftUI

struct SubscriptionButtonView: View {
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    var body: some View {
        if subscriptionManager.isPurchased {
            Text("premium")
        } else {
            Button(action: {
                subscriptionManager.purchaseSubscription()
            }) {
                HStack {
                    Image(systemName: "rectangle.on.rectangle.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Remove Ads")
                    Spacer()
                }
            }
        }
    }
}

struct SubscriptionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionButtonView()
    }
}
