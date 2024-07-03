//
//  WritePostViewModelTest.swift
//  ClesetTests
//
//  Created by 엄태양 on 6/26/24.
//

@testable import Cleset
import XCTest
import SwiftUI
import Combine
import PhotosUI

final class WritePostViewModelTest: XCTestCase {

    var viewModel: WritePostViewModel = WritePostViewModel(container: .stub, boardType: .tip)
    
    func testSaveButtonTapWithEmptyTitle() {
        //given
        let title: String = ""
        let boardType: BoardType = .fashion
        let postBody: String = "Good!"
        
        //when
        viewModel.send(.saveButtonTap(title: title, boardType: boardType, postBody: postBody))
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "게시글 제목을 입력해주세요.")
    }
    
    func testSaveButtonTapWithEmptyBody() {
        //given
        let title: String = "Title!!"
        let boardType: BoardType = .fashion
        let postBody: String = ""
        
        //when
        viewModel.send(.saveButtonTap(title: title, boardType: boardType, postBody: postBody))
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, false)
        XCTAssertEqual(viewModel.alertData?.description, "게시글 내용을 입력해주세요.")
    }
    
    func testSaveButtonTapWithPerfectInputInCreateMode() {
        //given
        let title: String = "Title!!"
        let boardType: BoardType = .fashion
        let postBody: String = "Good Post"
        let expectation: XCTestExpectation = expectation(description: "Create Post")
        
        //when
        viewModel.send(.saveButtonTap(title: title, boardType: boardType, postBody: postBody) {
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, true)
        XCTAssertEqual(viewModel.alertData?.description, "게시글 작성에 성공했습니다!")
    }
    
    func testSaveButtonTapWithPerfectInputInEditMode() {
        //given
        let prevPost = Post.stubList[1]
        viewModel = WritePostViewModel(container: .stub, boardType: .tip, postData: prevPost)
        
        let title: String = "Title!!"
        let boardType: BoardType = .fashion
        let postBody: String = "Good Post"
        let expectation: XCTestExpectation = expectation(description: "Create Post")
        
        //when
        viewModel.send(.saveButtonTap(title: title, boardType: boardType, postBody: postBody) {
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(viewModel.alertData)
        XCTAssertEqual(viewModel.alertData?.result, true)
        XCTAssertEqual(viewModel.alertData?.description, "게시글 수정에 성공했습니다!")
    }
}
