//
//  EditProfileViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/29/24.
//

import Foundation
import Combine

final class EditProfileViewModel: ObservableObject {
    
    enum Action {
        case nicknameChanged(String)
        case nicknameCheckButtonTap(String)
        case updateButtonTap(nickname: String, gender: Gender, age: Int)
    }
    
    private var nicknameCheck: Bool = true
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    var alertData: AlertData? = nil
    @Published var presentingAlert: Bool = false
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case let .nicknameChanged(newNickname):
                nicknameCheck = newNickname == UserManager.getUserData()?.nickname
                
            case let .nicknameCheckButtonTap(nickname):
                
                if let user = UserManager.getUserData(),
                   user.nickname == nickname {
                    alertData = AlertData(result: true, title: "알림", description: "현재 사용중인 닉네임입니다.")
                    presentingAlert = true
                    return
                }
                
                container.services.userService.nicknameCheck(nickname: nickname)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: {[weak self] alreadyUsed in
                        if alreadyUsed == false {
                            self?.alertData = AlertData(result: true, title: "성공", description: "사용 가능한 닉네임 입니다.")
                            self?.presentingAlert = true
                            self?.nicknameCheck = true
                        } else {
                            self?.alertData = AlertData(result: false, title: "실패", description: "이미 사용중인 닉네임입니다.")
                            self?.presentingAlert = true
                            self?.nicknameCheck = false
                        }
                    }.store(in: &subscriptions)
                
                
            case let .updateButtonTap(nickname, gender, age):
                if nicknameCheck == false {
                    alertData = AlertData(result: false, title: "실패", description: "닉네임 중복확인을 해주세요")
                    presentingAlert = true
                }
                
                if let user = UserManager.getUserData(), inputCheck(nickname: nickname) {
                    let updateUser = UserModel(id: user.id, nickname: nickname, gender: gender, age: age, uid: user.uid)
                    container.services.userService.updateUser(user: updateUser)
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] completion in
                            switch completion {
                                case .failure:
                                    self?.alertData = AlertData(result: true, title: "실패", description: "오류가 발생했습니다.\n잠시후 다시 시도해주세요.", dismiss: true)
                                    self?.presentingAlert = true
                                default:
                                    break
                            }
                        } receiveValue: {[weak self] userData in
                            UserManager.setUserData(with: userData)
                            self?.alertData = AlertData(result: true, title: "성공", description: "정상적으로 수정되었습니다.", dismiss: true)
                            self?.presentingAlert = true
                        }
                        .store(in: &subscriptions)
                }
        }
    }
    
    func inputCheck(nickname: String) -> Bool {
        if nickname == "" {
            return false
        }
        
        return true
    }
    
}
