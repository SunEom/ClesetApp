//
//  PostView.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: PostViewModel
    @State var isPresentingDeleteConfirmAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationHeader(button: postViewRightBarButton)
            
            ScrollView {
               
                postContentView
                
                Rectangle().fill(Color.gray0)
                    .frame(height: 1)
                    .padding(.vertical, 10)
                
                commentSection
                
                
            }
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.send(.fetchPostDetail)
            viewModel.send(.fetchComments)
        }
        .alert(isPresented: $isPresentingDeleteConfirmAlert, content: {
            Alert(
                title: Text("경고"),
                message: Text("정말로 게시글을 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    viewModel.send(.deletePost {
                        dismiss()
                    })
                },
                secondaryButton: .cancel(Text("삭제")))
        })
    }
    
    var postViewRightBarButton: some View {
        viewModel.postData.userId == UserManager.getUserData()?.id ?
        
        Menu {
           NavigationLink {
               WritePostView(viewModel:
                               WritePostViewModel(
                                   container: container,
                                   boardType: viewModel.postData.boardType,
                                   postData: viewModel.postData
                               )
               ).onDisappear {
                   viewModel.send(.fetchPostDetail)
               }
           } label: {
               HStack {
                   Text("수정하기")
                   Image("edit")
                       .renderingMode(.template)
                       .foregroundStyle(Color.bk)
               }
           }
           
           Button {
               isPresentingDeleteConfirmAlert = true
           } label: {
               HStack {
                   Text("삭제하기")
                   Image(systemName: "trash")
               }
           }
       } label: {
           Image("verticalEllipsis")
               .resizable()
               .renderingMode(.template)
               .frame(width: 15, height: 15)
               .foregroundStyle(Color.bk)
       }.menuStyle(.button)
        : nil
    }
    
    
    var postContentView: some View {
        LazyVStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(viewModel.postData.title)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Button {
                    viewModel.send(.favoriteButtonTap)
                } label: {
                    HStack {
                        Image(systemName: viewModel.favorite ? "heart.fill" : "heart")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.red)
                            .frame(width: 18, height: 16)
                        
                        Text("\(viewModel.favoriteCount)")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.red)
                    }
                    .padding(3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 10)
            
            HStack {
                Text(viewModel.postData.nickname)
                
                Spacer()
                
                Text(BoardType(rawValue: viewModel.postData.genre)!.displayName)
                
            }
            .font(.system(size: 12))
            .padding(.vertical, -10)
            
            if let url = viewModel.postData.imageURL {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width - 30)
                    .padding(.top, 20)
            }
            
            Text(viewModel.postData.postBody)
                .font(.system(size: 13))
                .padding(.top, 20)
            
        }.padding(.horizontal, 20)
    }
    
    var commentSection: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                CommentListView(
                    viewModel: CommentListViewModel(
                        container: container,
                        postData: viewModel.postData
                    )
                )
            } label: {
                HStack {
                    Text("댓글 \(!viewModel.comments.isEmpty ? "(\(viewModel.comments.count))" : "")")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "chevron.right")
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if !viewModel.comments.prefix(3).isEmpty {
                LazyVStack {
                    ForEach(viewModel.comments.prefix(3), id:\.commentId) { comment in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comment.nickname)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                
                                Spacer()
                                
                                Text(comment.createdDate.getFormattedDate())
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color.gray)
                            }
                            .padding(.bottom, 2)
                            
                            Text(comment.commentBody)
                                .font(.system(size: 12))
                                .lineLimit(2)
                            
                            if viewModel.comments.prefix(3).last?.commentId != comment.commentId {
                                Rectangle()
                                    .fill(Color.gray0)
                                    .frame(height: 1)
                            }
                            
                        }
                        .padding(.vertical, 4)
                    }
                }
            } else {
                HStack {
                    Spacer()
                    VStack {
                        Image("emptyComment")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                        
                        Text("작성된 댓글이 없습니다.")
                            .font(.system(size: 13))
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
                
            }
            
            HStack {
                Spacer()
                NavigationLink {
                    CommentListView(viewModel: CommentListViewModel(container: container, postData: viewModel.postData))
                } label: {
                    Text("댓글 작성하기")
                        .foregroundStyle(Color.white)
                        .frame(width: UIScreen.main.bounds.width-50, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.mainGreen)
                        )
                }
                Spacer()
            }
            .padding(.vertical, 20)
            
            
        }.padding(.horizontal, 20)
    }
    
}


#Preview {
    PostView(viewModel: PostViewModel(container: .stub, postData: .stubList[0]))
}
