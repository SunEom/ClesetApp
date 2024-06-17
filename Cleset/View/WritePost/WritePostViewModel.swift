//
//  WritePostViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/9/24.
//

import SwiftUI
import Combine
import PhotosUI
import Kingfisher

enum WritePostMode {
    case create
    case update
}

final class WritePostViewModel: ObservableObject {
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var alertData: AlertData? = nil
    @Published var selectedImagePreview: Image? = nil
    private var selectedImageData: Data? = nil
    let postData: Post?
    let boardType: BoardType
    var mode: WritePostMode {
        postData == nil ? .create : .update
    }
    
    init(container: DIContainer, boardType: BoardType, postData: Post? = nil) {
        self.container = container
        self.boardType = boardType
        self.postData = postData
        
        //이미지 값 초기화
        if let postData = postData,
           let imageURL = postData.imageURL {
            let downloader = ImageDownloader.default
            downloader.downloadImage(with: imageURL) { [weak self] result in
                switch result {
                    case .success(let value):
                        // 다운로드된 이미지 데이터 반환
                        self?.selectedImageData = value.originalData
                        self?.selectedImagePreview = Image(uiImage: UIImage(data: value.originalData)!)
                    case .failure(let error):
                        print("Error downloading image: \(error.localizedDescription)")
                }
            }
        }
    }
    
    enum Action {
        case imageSelected(PhotosPickerItem?)
        case imageDisselected
        case saveButtonTap(title: String, boardType: BoardType, postBody: String)
        case alertDismiss
    }
    
    func send(_ action: Action) {
        switch action {
            case let .imageSelected(photosItem):
                Task {
                    if let data = try? await photosItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data), let optimizedData = uiImage.downscaleTOjpegData(maxBytes: 500_000) {
                            self.selectedImageData = optimizedData
                            let image = Image(uiImage: uiImage)
                            DispatchQueue.main.async {
                                self.selectedImagePreview = image
                            }
                        }
                    }
                }
                
            case .imageDisselected:
                selectedImageData = nil
                selectedImagePreview = nil
                
            case let .saveButtonTap(title, boardType, postBody):
                switch mode {
                    case .create:
                        container.services
                            .postService
                            .createNewPost(boardType: boardType, title: title, postBody: postBody, imageData: selectedImageData)
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                            } receiveValue: { [weak self] _ in
                                self?.alertData = AlertData(result: true, title: "성공", description: "게시글 작성에 성공했습니다!")
                            }.store(in: &subscriptions)
                        
                    case .update:
                        container.services
                            .postService
                            .updatePost(postId: postData!.postId, boardType: boardType, title: title, postBody: postBody, imageData: selectedImageData)
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                            } receiveValue: { [weak self] _ in
                                self?.alertData = AlertData(result: true, title: "성공", description: "게시글 수정에 성공했습니다!")
                            }.store(in: &subscriptions)
                }
                
            case .alertDismiss:
                alertData = nil
        }
    }
}
