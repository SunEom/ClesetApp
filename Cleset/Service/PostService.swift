//
//  PostService.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation
import Combine

protocol PostServiceType {
    func getMyPost() -> AnyPublisher<[Post], ServiceError>
    func fetchPostDetail(postId: Int) -> AnyPublisher<PostDetail, ServiceError>
    func fetchPostsWithBoardType(with type: BoardType) -> AnyPublisher<[Post], ServiceError>
    func createNewPost(boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, ServiceError>
    func updatePost(postId: Int, boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, ServiceError>
}

final class PostService: PostServiceType {
    
    let postRepository: PostRepository = NetworkPostRepository()
    
    func getMyPost() -> AnyPublisher<[Post], ServiceError> {
        return postRepository
            .getMyPosts()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchPostDetail(postId: Int) -> AnyPublisher<PostDetail, ServiceError> {
        return postRepository
            .fetchPostDetail(postId: postId)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchPostsWithBoardType(with type: BoardType) -> AnyPublisher<[Post], ServiceError> {
        return postRepository
            .fetchPostsWithBoardType(with: type)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func createNewPost(boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, ServiceError> {
        return postRepository
            .createNewPost(boardType: boardType, title: title, postBody: postBody, imageData: imageData)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func updatePost(postId: Int, boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, ServiceError> {
        return postRepository
            .updatePost(postId: postId, boardType: boardType, title: title, postBody: postBody, imageData: imageData)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubPostService: PostServiceType {
    func getMyPost() -> AnyPublisher<[Post], ServiceError> {
        return Just(Post.stubList)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPostDetail(postId: Int) -> AnyPublisher<PostDetail, ServiceError> {
        return Just(PostDetail(post: Post.stubList[0], favorite: 1, favoriteCount: 1))
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPostsWithBoardType(with type: BoardType) -> AnyPublisher<[Post], ServiceError> {
        return Just(Post.stubList)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func createNewPost(boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func updatePost(postId: Int, boardType: BoardType, title: String, postBody: String, imageData: Data?) -> AnyPublisher<Post, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
