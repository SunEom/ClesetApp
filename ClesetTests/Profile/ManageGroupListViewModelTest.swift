//
//  ManageGroupListViewModelTest.swift
//  ClesetTests
//
//  Created by 엄태양 on 7/2/24.
//

@testable import Cleset
import XCTest

final class ManageGroupListViewModelTest: XCTestCase {

    let viewModel: ManageGroupListViewModel = ManageGroupListViewModel(container: .stub)


    func testFetchGroupList() {
        //given
        let stubList = ClothGroupObject.stubList
        let expectation: XCTestExpectation = expectation(description: "wait for fetching group process")
        
        //when
        viewModel.send(.fetchGroupList {
            expectation.fulfill()
        })
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(viewModel.groupList, stubList)
    }
    
}
