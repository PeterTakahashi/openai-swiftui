//
//  MarkdownText.swift
//  OpenAI
//
//  Created by Apple on 2023/04/07.
//

import SwiftUI
import SwiftRichString
import UIKit

struct MarkdownText: UIViewRepresentable {
    var markdown: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.attributedText = convertToAttributedString(from: markdown)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = convertToAttributedString(from: markdown)
    }

    private func convertToAttributedString(from markdown: String) -> NSAttributedString {
        let parser = MarkdownParser(font: UIFont.systemFont(ofSize: 16))
        parser.bold.font = UIFont.boldSystemFont(ofSize: 16)
        parser.italic.font = UIFont.italicSystemFont(ofSize: 16)
        
        let attributedString = parser.attributedString(from: markdown)
        return attributedString
    }
}


struct MarkdownText_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownText(markdown: "# hello  world")
    }
}
