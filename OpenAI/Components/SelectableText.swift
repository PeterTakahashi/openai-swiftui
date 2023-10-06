//
//  SelectableText.swift
//  OpenAI
//
//  Created by Apple on 2023/04/07.
//

import SwiftUI
import UIKit

struct SelectableText: UIViewRepresentable {
    let text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: SelectableText
        
        init(_ parent: SelectableText) {
            self.parent = parent
        }
    }
}


struct SelectableText_Previews: PreviewProvider {
    static var previews: some View {
        SelectableText(text: "This is selectable text.")
    }
}
