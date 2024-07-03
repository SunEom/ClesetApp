//
//  SignUpViewModelTest.swift
//  ClesetTests
//
//  Created by 엄태양 on 6/26/24.
//

@testable import Cleset
import XCTest
import Combine

final class SignUpViewModelTest: XCTestCase {
    
    let viewModel: SignUpViewModel = SignUpViewModel(container: .stub)
    
    //MARK: - 닉네임 중복확인 버튼
    
    func testTapNicknameCheckButtonWithEmptyNickname () {
        //given
        let nickname: String = ""
        
        //when
        viewModel.send(.nicknameCheckButtonTap(nickname))
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "닉네임을 입력해주세요.")
    }
    
    func testTapNicknameCheckButtonWithGoodNickname () {
        //given
        let nickname: String = "GoodNickname"
        let expectation = expectation(description: "Nickname Check")
        
        //when
        
        viewModel.send(.nicknameCheckButtonTap(nickname, {
            expectation.fulfill()
        }))
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, true)
        XCTAssertEqual(viewModel.alertData?.description, "사용 가능한 닉네임 입니다.")
    }
    
    //MARK: - 회원가입 버튼
    
    func testSignUpButtonTapWithEmptyNickname() {
        //given
        let nickname: String = ""
        let gender: Gender = Gender.male
        let age: Int = 24
        
        //when
        viewModel.send(
            .signUpButtonTap(
                nickname: nickname,
                gender: gender,
                age: age
            )
        )
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "닉네임을 입력해주세요.")
    }
    
    func testSignUpButtonTapWithEmptyNicknameAndUnavailableAge() {
        //given
        let nickname: String = ""
        let gender: Gender = Gender.male
        let age: Int = 0
        
        //when
        viewModel.send(
            .signUpButtonTap(
                nickname: nickname,
                gender: gender,
                age: age
            )
        )
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "닉네임을 입력해주세요.")
    }
    
    func testSignUpButtonTapWithZeroAge() {
        //given
        let nickname: String = "GoodNickname"
        let gender: Gender = Gender.male
        let age: Int = 0
        let expectation = expectation(description: "wait for SignUp")
        
        //when
        viewModel.send(.nicknameCheckButtonTap(nickname) { [weak self] in
            self?.viewModel.send(
                .signUpButtonTap(
                    nickname: nickname,
                    gender: gender,
                    age: age
                ) {
                    expectation.fulfill()
                }
            )
        })
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "나이를 입력해주세요.")
    }
    
    func testSignUpButtonTapWithoutNicknameCheck() {
        //given
        let nickname: String = "GoodNickname"
        let gender: Gender = Gender.male
        let age: Int = 0
        let expectation = expectation(description: "wait for SignUp")
        
        //when
        viewModel.send(
            .signUpButtonTap(
                nickname: nickname,
                gender: gender,
                age: age
            ) {
                expectation.fulfill()
            }
        )
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "닉네임 중복확인을 해주세요")
    }
    
    func testSignUpButtonTapWhenChangeNicknameAfterNicknameCheck() {
        //given
        var nickname: String = "GoodNickname"
        let gender: Gender = Gender.male
        let age: Int = 24
        let expectation = expectation(description: "wait for SignUp")
        
        //when
        viewModel.send(.nicknameCheckButtonTap(nickname, { [weak self] in
            XCTAssertNotNil(self?.viewModel.alertData)
            XCTAssertEqual(self?.viewModel.alertData?.result, true)
            XCTAssertEqual(self?.viewModel.alertData?.description, "사용 가능한 닉네임 입니다.")
            
            nickname = "AnotherNickname"
            self?.viewModel.send(.nicknameChanged(nickname, {
                self?.viewModel.send(.signUpButtonTap(nickname: nickname, gender: gender, age: age, completion: {
                    expectation.fulfill()
                }))
            }))
        }))
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "닉네임 중복확인을 해주세요")
    }
    
    func testSignUpButtonTapWithPerfectInput() {
        //given
        let nickname: String = "GoodNickname"
        let gender: Gender = Gender.male
        let age: Int = 24
        let expectation = expectation(description: "SignUp success")
        
        //when
        viewModel.send(.nicknameCheckButtonTap(nickname) { [weak self] in
            self?.viewModel.send(
                .signUpButtonTap(
                    nickname: nickname,
                    gender: gender,
                    age: age
                ) {
                    expectation.fulfill()
                }
            )
        })
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, true)
        XCTAssertEqual(viewModel.alertData?.description, "회원가입에 성공했습니다!\n다시 한번 로그인 과정을 진행해주세요.")
    }
    
}
