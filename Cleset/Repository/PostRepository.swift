//
//  PostRepository.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation
import Combine

enum PostRepositoryError: Error {
    case customError(Error)
}

protocol PostRepository {
    func getMyPosts() -> AnyPublisher<[Post], PostRepositoryError>
    func fetchPostDetail(postId: Int) -> AnyPublisher<PostDetail, PostRepositoryError>
    func fetchPostsWithBoardType(with type: BoardType) -> AnyPublisher<[Post], PostRepositoryError>
    func createNewPost(boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, PostRepositoryError>
    func updatePost(postId: Int, boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, PostRepositoryError>
}

final class NetworkPostRepository: NetworkRepository, PostRepository {
    func getMyPosts() -> AnyPublisher<[Post], PostRepositoryError> {
        return postData(withPath: "mypage/post")
            .decode(type: [Post].self, decoder: JSONDecoder())
            .mapError { PostRepositoryError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchPostDetail(postId: Int) -> AnyPublisher<PostDetail, PostRepositoryError> {
        return postData(withPath: "post/\(postId)")
            .decode(type: PostDetail.self, decoder: JSONDecoder())
            .mapError { PostRepositoryError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchPostsWithBoardType(with type: BoardType) -> AnyPublisher<[Post], PostRepositoryError> {
        return fetchData(withPath: "post/\(type.typeString)")
            .decode(type: [Post].self, decoder: JSONDecoder())
            .mapError { PostRepositoryError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func createNewPost(boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, PostRepositoryError> {
        let body: [String: Any] = [
            "genre": boardType.rawValue,
            "title": title,
            "post_body": postBody
        ]
        
        return postData(withPath: "post/create", body: body, imageData: imageData, bodyName: "createPostReq")
            .decode(type: Post.self, decoder: JSONDecoder())
            .mapError { PostRepositoryError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func updatePost(postId: Int, boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, PostRepositoryError> {
        let body: [String: Any] = [
            "post_id": postId,
            "genre": boardType.rawValue,
            "title": title,
            "post_body": postBody
        ]
        
        return postData(withPath: "post/update", body: body, imageData: imageData, bodyName: "updatePostReq")
            .decode(type: Post.self, decoder: JSONDecoder())
            .mapError { PostRepositoryError.customError($0) }
            .eraseToAnyPublisher()
    }
    
}
