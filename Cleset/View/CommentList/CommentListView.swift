//
//  CommentListView.swift
//  Cleset
//
//  Created by 엄태양 on 5/7/24.
//

import SwiftUI

struct CommentListView: View {
    @StateObject var viewModel: CommentListViewModel
    @State var comment: String = ""
    @State var isPresentDeleteConfirmAlert: Bool = false
    @State var isPresentEditView: Bool = false
    @State var targetComment: Comment?
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: viewModel.postData.title)
            ScrollView{
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.comments, id: \.commentId){ comment in
                        CommentItem(
                            viewModel: viewModel,
                            comment: comment,
                            isLastComment: viewModel.comments.last?.commentId == comment.commentId,
                            isPresentDeleteConfirmAlert: $isPresentDeleteConfirmAlert,
                            isPresentEditView: $isPresentEditView,
                            targetComment: $targetComment
                        )
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.send(.fetchComments)
        }
        .keyboardToolbar(height: 50) {
            VStack {
                Rectangle().fill(Color.gray0)
                    .frame(height: 1)
                
                HStack {
                    TextEditor(text: $comment)
                    
                    Button {
                        viewModel.send(.createComment(comment))
                        comment = ""
                    } label: {
                        Image("paperPlane")
                            .resizable()
                            .frame(width: 45, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
            }
            
        }
        .alert(isPresented: Binding(get: {
            isPresentDeleteConfirmAlert && targetComment != nil
        }, set: { _ in
        }), content: {
            Alert(
                title: Text("경고"),
                message: Text("정말로 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    viewModel.send(.deleteComment(targetComment!))
                    targetComment = nil
                    isPresentDeleteConfirmAlert = false
                },
                secondaryButton: .default(Text("취소")) {
                    targetComment = nil
                    isPresentDeleteConfirmAlert = false
                }
            )
        })
        .sheet(isPresented: Binding(get: {
            isPresentEditView && targetComment != nil
        }, set: { _ in
        }), content: {
            CommentEditView(
                viewModel: viewModel,
                comment: targetComment!,
                editedComment: targetComment!.commentBody,
                isPresentEditView: $isPresentEditView
            )
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.automatic)
            .onDisappear {
                targetComment = nil
                isPresentEditView = false
            }
        })
    }
}

struct CommentItem: View {
    var viewModel: CommentListViewModel
    var comment: Comment
    var isLastComment: Bool
    
    @Binding var isPresentDeleteConfirmAlert: Bool
    @Binding var isPresentEditView: Bool
    @Binding var targetComment: Comment?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.nickname)
                    .font(.system(size: 14, weight: .semibold))
                
                Spacer()
                if let user = UserManager.getUserData(),
                   user.id == comment.id {
                    Menu {
                        Button{
                            targetComment = comment
                            isPresentEditView = true
                        } label: {
                            HStack {
                                Text("수정")
                                Spacer()
                                Image("edit")
                            }
                        }
                        
                        Button{
                            targetComment = comment
                            isPresentDeleteConfirmAlert = true
                        } label: {
                            HStack {
                                Text("삭제")
                                Spacer()
                                Image(systemName: "trash")
                            }
                        }.foregroundStyle(Color.red)
                    } label: {
                        Image("verticalEllipsis")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                
                
            }.padding(.bottom, 2)
            
            Text(comment.commentBody)
                .font(.system(size: 12))
            
            HStack {
                Spacer()
                Text(comment.createdDate.getFormattedDate())
                    .font(.system(size: 10))
                    .foregroundStyle(Color.gray)
            }
            
            if !isLastComment {
                Rectangle()
                    .fill(Color.gray0)
                    .frame(height: 1)
                    .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 20)
    }
    
}

struct CommentEditView: View {
    var viewModel: CommentListViewModel
    var comment: Comment
    @State var editedComment: String
    @Binding var isPresentEditView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("댓글 수정")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Button {
                    if !editedComment.isEmpty {
                        viewModel.send(.updateComment(comment, editedComment))
                        isPresentEditView = false
                    }
                } label: {
                    Text("저장")
                }
            }
            
            
            TextEditor(text: $editedComment)
                .font(.system(size: 14))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .border(Color.gray0, width: 1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

#Preview {
    CommentListView(viewModel:
                        CommentListViewModel(
                            container: .stub,
                            postData: .stubList[0]
                        )
    )
}
