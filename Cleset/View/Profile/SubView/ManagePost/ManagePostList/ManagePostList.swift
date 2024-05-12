//
//  ManagePostList.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import SwiftUI

struct ManagePostList: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: ManagePostListViewModel
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: viewModel.menu.displayName)
            ForEach(viewModel.posts, id: \.postData.postId) { cellViewModel in
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
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.send(.fetchPosts)
        }
    }
}

#Preview {
    ManagePostList(viewModel: ManagePostListViewModel(container: .stub, menu: .myPost))
}
