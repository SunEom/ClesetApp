//
//  ManageClothByGroupViewModelTest.swift
//  ClesetTests
//
//  Created by 엄태양 on 7/3/24.
//

@testable import Cleset
import XCTest

final class ManageClothByGroupViewModelTest: XCTestCase {

    let viewModel: ManageClothByGroupViewModel = ManageClothByGroupViewModel(container: .stub)
    
    func testFetchClothGroups() {
        //given
        let stubList = ClothGroupObject.stubList
        let expectation: XCTestExpectation = expectation(description: "wait for fetching cloth groups")
        
        //when
        viewModel.send(.fetchGroups{
            expectation.fulfill()
        })
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(viewModel.groups, stubList)
        
    }
    
    func testFetchClothsInGroup() {
        //given
        let stubList = ClothObject.stubList
        let targetGroup = ClothGroupObject(id: "1", folderId: 1, folderName: "Temp Group", userId: 1)
        let expectation: XCTestExpectation = expectation(description: "wait for fetching cloth process")
        
        //when
        viewModel.send(.fetchGroupCloth(targetGroup, {
            expectation.fulfill()
        }))
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(viewModel.clothes.count, stubList.count)
    }
    
    func testFilterClothesWithTitleKeyword() {
        //given
        let stubList = ClothObject.stubList
        let targetGroup = ClothGroupObject(id: "1", folderId: 1, folderName: "Temp Group", userId: 1)
        let expectation: XCTestExpectation = expectation(description: "wait for fetching cloth process")
        let title: String = stubList[0].name
        var result: [ClothCellViewModel]?
        
        //when
        viewModel.send(.fetchGroupCloth(targetGroup, { [weak self] in
            result = self?.viewModel.getFilteredList(for: title)
            expectation.fulfill()
        }))
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[0].clothData.name, stubList[0].name)
    }
    
    func testFilterClothesWithBrandKeyword() {
        //given
        let stubList = ClothObject.stubList
        let targetGroup = ClothGroupObject(id: "1", folderId: 1, folderName: "Temp Group", userId: 1)
        let expectation: XCTestExpectation = expectation(description: "wait for fetching cloth process")
        let brand: String = stubList[0].brand
        var result: [ClothCellViewModel]?
        
        //when
        viewModel.send(.fetchGroupCloth(targetGroup, { [weak self] in
            result = self?.viewModel.getFilteredList(for: brand)
            expectation.fulfill()
        }))
        
        //then
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[0].clothData.name, stubList[0].name)
    }
    
}
