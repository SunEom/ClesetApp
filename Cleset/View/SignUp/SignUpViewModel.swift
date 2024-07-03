//
//  SignUpViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var isNicknameChecked: Bool = false
    private var recentCheckedNickname: String? = nil
    
    @Published var alertData: AlertData? = nil
    @Published var presentingAlert: Bool = false
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case nicknameChanged(String, () -> Void = {})
        case nicknameCheckButtonTap(String, () -> Void = {})
        case signUpButtonTap(nickname: String, gender: Gender, age: Int, completion: () -> Void = {} )
    }
    
    func send(_ action: Action) {
        switch action {
            case let .nicknameChanged(newNickname, completion):
                isNicknameChecked = newNickname == recentCheckedNickname
                completion()
                
            case let .nicknameCheckButtonTap(nickname, completion):
                if nickname == "" {
                    self.alertData = AlertData(result: false, title: "실패", description: "닉네임을 입력해주세요.")
                    self.presentingAlert = true
                    self.isNicknameChecked = false
                } else {
                    container.services.userService.nicknameCheck(nickname: nickname)
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                            completion()
                        } receiveValue: {[weak self] alreadyUsed in
                            if alreadyUsed == false {
                                self?.recentCheckedNickname = nickname
                                self?.alertData = AlertData(result: true, title: "성공", description: "사용 가능한 닉네임 입니다.")
                                self?.presentingAlert = true
                                self?.isNicknameChecked = true
                            } else {
                                self?.alertData = AlertData(result: false, title: "실패", description: "이미 사용중인 닉네임입니다.")
                                self?.presentingAlert = true
                                self?.isNicknameChecked = false
                            }
                        }.store(in: &subscriptions)
                }
                
                
            case let .signUpButtonTap(nickname, gender, age, completion):
                if nickname == "" {
                    self.alertData = AlertData(result: false, title: "실패", description: "닉네임을 입력해주세요.")
                    self.presentingAlert = true
                    completion()
                } else if isNicknameChecked == false {
                    alertData = AlertData(result: false, title: "실패", description: "닉네임 중복확인을 해주세요")
                    presentingAlert = true
                    completion()
                } else if age == 0 {
                    self.alertData = AlertData(result: false, title: "실패", description: "나이를 입력해주세요.")
                    self.presentingAlert = true
                    completion()
                } else {
                    container.services.userService.signUpUser(nickname: nickname, gender: gender, age: age)
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] result in
                            switch result {
                                case .failure:
                                    self?.alertData = AlertData(result: true, title: "실패", description: "오류가 발생했습니다.\n잠시후 다시 시도해주세요.", dismiss: true)
                                    self?.presentingAlert = true
                                default:
                                    completion()
                            }
                            
                        } receiveValue: {[weak self] userData in
                            UserManager.setUserData(with: userData)
                            self?.alertData = AlertData(result: true, title: "성공", description: "회원가입에 성공했습니다!\n다시 한번 로그인 과정을 진행해주세요.", dismiss: true)
                            self?.presentingAlert = true
                        }
                        .store(in: &subscriptions)
                }
                
                
        }
    }
}
