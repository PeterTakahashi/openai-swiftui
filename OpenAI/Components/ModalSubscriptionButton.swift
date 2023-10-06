//
//  ModalSubscriptionButton.swift
//  OpenAI
//
//  Created by Apple on 2023/04/08.
//

import SwiftUI

struct ModalSubscriptionButton: View {
    var action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "rectangle.on.rectangle.slash.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                
                Text("Remove Ads")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
            }
            .foregroundColor(Color(.systemBackground))
            .padding(.horizontal, 16)
            .background(colorScheme == .dark ? LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

struct ModalSubscriptionButton_Previews: PreviewProvider {
    static var previews: some View {
        ModalSubscriptionButton() {}
    }
}
