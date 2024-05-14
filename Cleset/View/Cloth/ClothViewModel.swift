//
//  ClothViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/13/24.
//

import SwiftUI
import PhotosUI
import Combine
import Kingfisher

enum ClothViewMode {
    case create
    case update
}

final class ClothViewModel: ObservableObject {
    private let container: DIContainer
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    let clothData: ClothObject?
    
    @Published var alertData: AlertData? = nil
    @Published var selectedImagePreview: Image? = nil
    private var selectedImageData: Data? = nil
    var mode: ClothViewMode {
        clothData == nil ? .create : .update
    }
    
    init(container: DIContainer, clothData: ClothObject? = nil) {
        self.container = container
        self.clothData = clothData
        
        //이미지 값 초기화
        if let clothData = clothData,
           let imageURL = clothData.imageUrl {
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
        case saveButtonTap(name: String, category: Category, brand: String, size: String, place: String, season: [Season], memo: String)
        case alertDismiss
    }
    
    func send(_ action: Action) {
        switch action {
            case let .imageSelected(photosItem):
                Task {
                    if let data = try? await photosItem?.loadTransferable(type: Data.self) {
                        self.selectedImageData = data
                        if let uiImage = UIImage(data: data) {
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
                
            case let .saveButtonTap(name, category, brand, size, place, season, memo):
                switch mode {
                    case .create:
                        container.services
                            .clothService
                            .createNewCloth(name: name, category: category, brand: brand, size: size, place: place, season: season, memo: memo, imageData: selectedImageData)
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                            } receiveValue: { [weak self] _ in
                                self?.alertData = AlertData(result: true, title: "성공", description: "의상 추가에 성공했습니다!")
                            }.store(in: &subscriptions)
                        
                    case .update:
                        container.services
                            .clothService
                            .updateCloth(clothId: clothData!.clothId,name: name, category: category, brand: brand, size: size, place: place, season: season, memo: memo, imageData: selectedImageData)
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                            } receiveValue: { [weak self] _ in
                                self?.alertData = AlertData(result: true, title: "성공", description: "의상 정보 수정에 성공했습니다!")
                            }.store(in: &subscriptions)
                }
                
            case .alertDismiss:
                alertData = nil
        }
    }
}
