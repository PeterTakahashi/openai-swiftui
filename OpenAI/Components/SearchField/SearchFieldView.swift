//
//  SearchFieldView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/06.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var currentPage: Int
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                TextField("", text: self.$searchText, onCommit: {
                    currentPage = 1
                })
                    .padding(.leading, 40)
                    .padding(.trailing, searchText.isEmpty ? 0 : 30)
                    .frame(height: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 30)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        currentPage = 1
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    .padding(.trailing, 10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(currentPage: .constant(1), searchText: .constant("text"))
    }
}
