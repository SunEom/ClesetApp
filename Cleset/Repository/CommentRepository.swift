//
//  CommentRepository.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import Foundation
import Combine

protocol CommentRepository {
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], NetworkError>
    func createComment(postId: Int, commentBody: String) -> AnyPublisher<[Comment], NetworkError>
    func updateComment(postId: Int, commentId: Int, newCommentBody: String) -> AnyPublisher<[Comment], NetworkError>
    func deleteComment(postId: Int, commentId: Int) -> AnyPublisher<[Comment], NetworkError>
}

final class NetworkCommentRepository: NetworkRepository, CommentRepository {
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], NetworkError> {
        return fetchData(withPath: "comment/\(postId)")
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func createComment(postId: Int, commentBody: String) -> AnyPublisher<[Comment], NetworkError> {
        let body: [String: Any] = [
            "post_id": postId,
            "comment_body": commentBody
        ]
        
        return postData(withPath: "comment/create", body: body)
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func updateComment(postId: Int, commentId: Int, newCommentBody: String) -> AnyPublisher<[Comment], NetworkError> {
        let body: [String: Any] = [
            "post_id": postId,
            "comment_id": commentId,
            "comment_body": newCommentBody
        ]
        
        return postData(withPath: "comment/update", body: body)
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteComment(postId: Int, commentId: Int) -> AnyPublisher<[Comment], NetworkError> {
        let body: [String: Any] = [
            "post_id": postId,
            "comment_id": commentId,
        ]
        
        return postData(withPath: "comment/delete", body: body)
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
}
