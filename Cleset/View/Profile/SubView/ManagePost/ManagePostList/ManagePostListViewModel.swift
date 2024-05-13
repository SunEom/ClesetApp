//
//  ManagePostListViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import Foundation
import Combine
final class ManagePostListViewModel: ObservableObject {
    private let container: DIContainer
    let menu: ManagePostMenu
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var postCellViewModels: [PostCellViewModel] = []
    
    init(container: DIContainer, menu: ManagePostMenu) {
        self.container = container
        self.menu = menu
    }
    
    enum Action {
        case fetchPosts
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchPosts:
                switch menu {
                    case .myPost:
                        container.services.postService
                            .fetchMyPost()
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                            } receiveValue: { [weak self] posts in
                                guard let self = self else { return }
                                self.postCellViewModels = posts.map { self.createViewModel(with: $0) }
                            }.store(in: &subscriptions)
                        
                    case .favorite:
                        container.services.postService
                            .fetchMyFavoritePosts()
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                            } receiveValue: { [weak self] posts in
                                guard let self = self else { return }
                                self.postCellViewModels = posts.map { self.createViewModel(with: $0)}
                            }.store(in: &subscriptions)
                }
        }
    }
    
    private func createViewModel(with post: Post) -> PostCellViewModel {
        return PostCellViewModel(postData: post)
    }
    
    func getFilteredList(for searchWord: String) -> [PostCellViewModel] {
        if searchWord == "" {
            return self.postCellViewModels
        } else {
            return self.postCellViewModels.filter { viewModel in
                viewModel.postData.filter(searchWord: searchWord)
            }
        }
    }
    
}
