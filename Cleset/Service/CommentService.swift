//
//  CommentService.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import Foundation
import Combine

protocol CommentServiceType {
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], ServiceError>
    func createComment(postId: Int, commentBody: String) -> AnyPublisher<[Comment], ServiceError>
    func updateComment(postId: Int, commentId: Int, newCommentBody: String) -> AnyPublisher<[Comment], ServiceError>
    func deleteComment(postId: Int, commentId: Int) -> AnyPublisher<[Comment], ServiceError>
}

final class CommentService: CommentServiceType {
    
    let commentRepository: CommentRepository = NetworkCommentRepository()
    
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], ServiceError> {
        return commentRepository
            .fetchComments(postId: postId)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
    
    func createComment(postId: Int, commentBody: String) -> AnyPublisher<[Comment], ServiceError> {
        return commentRepository
            .createComment(postId: postId, commentBody: commentBody)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateComment(postId: Int, commentId: Int, newCommentBody: String) -> AnyPublisher<[Comment], ServiceError> {
        return commentRepository
            .updateComment(postId: postId, commentId: commentId, newCommentBody: newCommentBody)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteComment(postId: Int, commentId: Int) -> AnyPublisher<[Comment], ServiceError> {
        return commentRepository
            .deleteComment(postId: postId, commentId: commentId)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubCommentService: CommentServiceType {
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], ServiceError> {
        return Just(Comment.stubList)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func createComment(postId: Int, commentBody: String) -> AnyPublisher<[Comment], ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func updateComment(postId: Int, commentId: Int, newCommentBody: String) -> AnyPublisher<[Comment], ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func deleteComment(postId: Int, commentId: Int) -> AnyPublisher<[Comment], ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
