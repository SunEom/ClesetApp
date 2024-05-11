//
//  BoardView.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import SwiftUI

struct BoardView: View {
    @StateObject var viewModel: BoardViewModel
    @EnvironmentObject var container: DIContainer
    var body: some View {
        VStack {
            NavigationHeader(button: NavigationLink(destination: {
                WritePostView(viewModel: WritePostViewModel(container: container, boardType: viewModel.boardType))
                    .onDisappear {
                        viewModel.send(.fetchPosts)
                    }
            }, label: {
                Text("작성")
            }), title: viewModel.boardType.displayName)
            
            LazyVStack {
                ForEach(viewModel.postCellViewModels, id: \.postData.id) { cellViewModel in
                    VStack(spacing: .zero) {
                        NavigationLink {
                            PostView(viewModel: PostViewModel(container: container, postData: cellViewModel.postData))
                                .onDisappear {
                                    viewModel.send(.fetchPosts)
                                }
                        } label: {
                            PostCell(viewModel: cellViewModel)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
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
