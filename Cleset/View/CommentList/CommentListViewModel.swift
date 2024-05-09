//
//  CommentListViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/7/24.
//

import Foundation
import Combine

final class CommentListViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    private let container: DIContainer
    
    let postData: Post
    @Published var comments: [Comment] = []
    @Published var loading: Bool = false
    
    init(container: DIContainer, postData: Post) {
        self.container = container
        self.postData = postData
    }
    
    enum Action {
        case fetchComments
        case createComment(String)
        case updateComment(Comment, String)
        case deleteComment(Comment)
    }
    
    
    func send(_ action: Action) {
        switch action {
            case .fetchComments:
                container.services.commentService.fetchComments(postId: postData.postId)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] comments in
                        self?.comments = comments
                    }.store(in: &subscriptions)

            case let .createComment(commentBody):
                container.services.commentService.createComment(postId: postData.postId, commentBody: commentBody)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] comments in
                        self?.comments = comments
                    }.store(in: &subscriptions)
                
            case let .updateComment(comment, editedComment):
                container.services.commentService.updateComment(postId: postData.postId, commentId: comment.commentId, newCommentBody: editedComment)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] comments in
                        self?.comments = comments
                    }.store(in: &subscriptions)
                
            case let .deleteComment(comment):
                container.services.commentService.deleteComment(postId: postData.postId, commentId: comment.commentId)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] comments in
                        self?.comments = comments
                    }.store(in: &subscriptions)
                
        }
    }
}
