//
//  SearchBar.swift
//  Cleset
//
//  Created by 엄태양 on 5/13/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchWord: String
    var body: some View {
        HStack {
            TextField(text: $searchWord) {
                HStack {
                    Text("검색어를 입력해주세요.")
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .submitLabel(.search)
            
            Image(systemName: "magnifyingglass")
                .padding(.trailing, 10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1.5)
        )
        
    }
}

#Preview {
    SearchBar(searchWord: Binding(get: { "" }, set: { _ in }))
}
