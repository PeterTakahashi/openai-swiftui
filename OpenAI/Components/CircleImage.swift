//
//  CircleImage.swift
//  OpenAI
//
//  Created by Apple on 2023/04/14.
//

import SwiftUI

struct CircleImage: View {
    var image: AnyView

    var body: some View {
        image
            .frame(width: 300, height: 300)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: AnyView(Image("sample").resizable()))
    }
}
