//
//  ManagePostView.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI


struct ManagePostView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: ManagePostViewModel
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "게시글 관리")
            ScrollView {
                LazyVStack(spacing: .zero) {
                    ForEach(viewModel.postCellViewModels, id: \.postData.postId) { cellViewModel in
                        NavigationLink {
                            PostView(viewModel: PostViewModel(container: container, postData: cellViewModel.postData))
                        } label: {
                            VStack(spacing: .zero) {
                                PostCell(viewModel: cellViewModel)
                                Rectangle()
                                    .fill(Color.gray0)
                                    .frame(height: 1)
                            }
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.send(.fetchMyPosts)
            }
        }
        
    }
    
}

#Preview {
    ManagePostView(viewModel: ManagePostViewModel(container: .stub))
}
