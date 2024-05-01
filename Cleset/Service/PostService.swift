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
}

final class PostService: PostServiceType {
    
    let postRepository: PostRepository = NetworkPostRepository()
    
    func getMyPost() -> AnyPublisher<[Post], ServiceError> {
        return postRepository
            .getMyPosts()
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
}
