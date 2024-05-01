//
//  PostCellViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation

final class PostCellViewModel: ObservableObject {
    @Published var postData: Post
    
    init(postData: Post) {
        self.postData = postData
    }
}
