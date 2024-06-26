//
//  PostViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import Foundation
import Combine

final class PostViewModel: ObservableObject {
    
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var postData: Post
    @Published var comments: [Comment] = []
    @Published var favorite: Bool = false
    @Published var favoriteCount: Int = 0
    
    init(container: DIContainer, postData: Post) {
        self.container = container
        self.postData = postData
    }
    
    enum Action {
        case fetchComments
        case fetchPostDetail
        case favoriteButtonTap
        case deletePost(completion: (() -> Void))
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchComments:
                container.services.commentService
                    .fetchComments(postId: postData.postId)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] comments in
                        self?.comments = comments
                    }.store(in: &subscriptions)
                
            case .fetchPostDetail:
                container.services.postService
                    .fetchPostDetail(postId: postData.postId)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] postDetail in
                        self?.postData = postDetail.post
                        self?.favorite = postDetail.favoriteBool
                        self?.favoriteCount = postDetail.favoriteCount
                    }.store(in: &subscriptions)

            case .favoriteButtonTap:
                container.services.postService
                    .toggleFavorite(postId: postData.postId, favorite: favorite)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] postDetail in
                        self?.postData = postDetail.post
                        self?.favorite = postDetail.favoriteBool
                        self?.favoriteCount = postDetail.favoriteCount
                    }.store(in: &subscriptions)
                
            case let .deletePost(completion):
                container.services.postService.deletePost(postId: postData.postId)
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                    } receiveValue: { _ in
                        completion()
                    }.store(in: &subscriptions)

        }
    }
}
