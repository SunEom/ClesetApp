//
//  ManagePostViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation
import Combine

final class ManagePostViewModel: ObservableObject {
    
    enum Action {
        case fetchMyPosts
    }
    
    @Published var postCellViewModels: [PostCellViewModel] = []
    
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchMyPosts:
                container.services.postService
                    .getMyPost()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] posts in
                        guard let self = self else { return }
                        self.postCellViewModels = posts.map { self.createViewModel(with: $0)}
                    }.store(in: &subscriptions)
        }
    }
    
    private func createViewModel(with post: Post) -> PostCellViewModel {
        return PostCellViewModel(postData: post)
    }
}
