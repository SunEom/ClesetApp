//
//  ManagePostView.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI


struct ManagePostView: View {
    @StateObject var viewModel: ManagePostViewModel
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "게시글 관리")
            ScrollView {
                LazyVStack(spacing: .zero) {
                    ForEach(viewModel.postCellViewModels, id: \.postData.postId) { viewModel in
                        NavigationLink {
                            //TODO: 게시글 상세화면으로 이동
                        } label: {
                            VStack(spacing: .zero) {
                                PostCell(viewModel: viewModel)
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
