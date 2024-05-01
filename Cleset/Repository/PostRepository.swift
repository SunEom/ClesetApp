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
}

final class NetworkPostRepository: NetworkRepository, PostRepository {
    func getMyPosts() -> AnyPublisher<[Post], PostRepositoryError> {
        return postData(withPath: "mypage/post")
            .decode(type: [Post].self, decoder: JSONDecoder())
            .mapError { PostRepositoryError.customError($0) }
            .eraseToAnyPublisher()
    }
}
