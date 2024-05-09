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
    let postData: Post
    @Published var comments: [Comment] = []
    
    init(container: DIContainer, postData: Post) {
        self.container = container
        self.postData = postData
    }
    
    enum Action {
        case fetchComments
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

        }
    }
}
