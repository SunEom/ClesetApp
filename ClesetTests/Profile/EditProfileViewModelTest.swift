//
//  EditProfileViewModelTest.swift
//  ClesetTests
//
//  Created by 엄태양 on 7/2/24.
//

@testable import Cleset
import XCTest
import Combine

final class EditProfileViewModelTest: XCTestCase {
    
    let viewModel: EditProfileViewModel = EditProfileViewModel(container: .stub)
    
    func testNicknameCheckButtonTapWithNickname() {
        //given
        let nickname: String = "new Nickname"
        let expectation: XCTestExpectation = expectation(description: "wait for nickname check")
        
        //when
        viewModel.send(.nicknameCheckButtonTap(nickname, expectation.fulfill))
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, true)
        XCTAssertEqual(viewModel.alertData?.description, "사용 가능한 닉네임 입니다.")
        
    }
    
    func testNicknameCheckWithAlreadyUsedNickname() {
        //given
        let tempUser: UserModel = .stub
        UserManager.setUserData(with: tempUser)
        let alreadyUsedNickname: String = tempUser.nickname
        
        //when
        self.viewModel.send(.nicknameCheckButtonTap(alreadyUsedNickname))
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "현재 사용중인 닉네임입니다.")
    }
    
    func testUpdateButtonTapWithoutNicknameChecking() {
        //given
        let tempUser: UserModel = .stub
        let nickname: String = "new Nickname"
        UserManager.setUserData(with: tempUser)
        let gender: Gender = .male
        let age: Int = 27
        let expectation: XCTestExpectation = expectation(description: "wait for profile update process")
        
        //when
        viewModel.send(.nicknameChanged(nickname, { [weak self] in
            self?.viewModel.send(.updateButtonTap(
                nickname: nickname,
                gender: gender,
                age: age,
                {
                    expectation.fulfill()
                }))
        }))
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "닉네임 중복확인을 해주세요.")
    }
    
    func testUpdateButtonTapPerfectProcess() {
        //given
        let nickname: String = "new Nickname"
        let gender: Gender = .male
        let age: Int = 27
        let expectation: XCTestExpectation = expectation(description: "wait for profile update process")
        
        //when
        viewModel.send(.nicknameCheckButtonTap(nickname, { [weak self] in
            self?.viewModel.send(.updateButtonTap(
                nickname: nickname,
                gender: gender,
                age: age,
                {
                    expectation.fulfill()
                }))
        }))
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, true)
        XCTAssertEqual(viewModel.alertData?.description, "정상적으로 수정되었습니다.")
    }
}
