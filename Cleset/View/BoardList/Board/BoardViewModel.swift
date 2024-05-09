//
//  BoardViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import Foundation
import Combine

final class BoardViewModel: ObservableObject {
    enum Action {
        case fetchPosts
    }
    
    private let container: DIContainer
    let boardType: BoardType
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var postCellViewModels: [PostCellViewModel] = []
    
    init(container: DIContainer, boardType: BoardType) {
        self.container = container
        self.boardType = boardType
    }

    func send(_ action: Action) {
        switch action {
            case .fetchPosts:
                container.services.postService.fetchPostsWithBoardType(with: boardType)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] postList in
                        guard let self = self else { return }
                        self.postCellViewModels = postList.map { self.createViewModel(with: $0) }
                    }
                    .store(in: &subscriptions)

        }
    }
    
    private func createViewModel(with post: Post) -> PostCellViewModel {
        return PostCellViewModel(postData: post)
    }
}
