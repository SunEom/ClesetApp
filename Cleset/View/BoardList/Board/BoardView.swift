//
//  BoardView.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import SwiftUI

struct BoardView: View {
    @StateObject var viewModel: BoardViewModel
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: viewModel.boardType.displayName)
            LazyVStack {
                ForEach(viewModel.postCellViewModels, id: \.postData.postId) { post in
                    VStack(spacing: .zero) {
                        PostCell(viewModel: post)
                        Rectangle()
                            .fill(Color.gray0)
                            .frame(height: 1)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            viewModel.send(.fetchPosts)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    BoardView(viewModel: BoardViewModel(container: .stub, boardType: .fashion))
}
