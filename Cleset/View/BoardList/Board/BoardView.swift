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
    @State var searchWord: String = ""
    
    var body: some View {
        VStack {
            NavigationHeader(button: NavigationLink(destination: {
                WritePostView(
                    viewModel:
                        WritePostViewModel(
                            container: container,
                            boardType: viewModel.boardType
                        )
                )
                .onDisappear {
                    viewModel.send(.fetchPosts)
                }
            }, label: {
                Text("작성")
            }), title: viewModel.boardType.displayName)
            
            if viewModel.loading {
                loadingView
            } else if viewModel.postCellViewModels.isEmpty {
                emptyContentView
            } else {
                contentView
            }
            
            Spacer()
        }
        .background(Color.background)
        .onAppear {
            viewModel.send(.fetchPosts)
        }
        .navigationBarBackButtonHidden()
        
    }
    
    var contentView: some View {
        VStack {
            SearchBar(searchWord: $searchWord)
                .padding(.horizontal, 20)
                .padding(.vertical, 1)
            
            LazyVStack {
                ForEach(viewModel.getFilteredList(for: searchWord), id: \.postData.id) { cellViewModel in
                    VStack(spacing: .zero) {
                        NavigationLink {
                            PostView(
                                viewModel: PostViewModel(
                                    container: container,
                                    postData: cellViewModel.postData
                                )
                            )
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
        }
    }

    var emptyContentView: some View {
        VStack {
            Spacer()
            HStack {
                Image("emptyBoard")
            }
            .padding(.bottom, 10)
            Text("작성된 게시글이 없습니다")
            Spacer()
        }
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

#Preview {
    BoardView(viewModel: BoardViewModel(container: .stub, boardType: .fashion))
}
