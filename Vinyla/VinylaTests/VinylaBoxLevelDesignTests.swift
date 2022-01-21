//
//  VinylaTests.swift
//  VinylaTests
//
//  Created by IJ . on 2021/07/28.
//

import XCTest
@testable import Vinyla
import CoreData

class VinylaBoxLevelDesignTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_async() {
        // given
        let expectation = XCTestExpectation(description: "API Request")
        let url        = URL(string: "https://apple.com")!
        var resultData: Data?

        let dataTask   = URLSession.shared.dataTask(with: url) { data, _, _ in
            resultData = data
            expectation.fulfill()
        }

        // when
        dataTask.resume()

        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(resultData)
        print(resultData)
    }

    func testVinylBoxViewModel() {
        //given
        var viewModel = VinylBoxViewModel()
        let dispatchGroup = DispatchGroup()
//        코어 데이터 전체 삭제 테스트 코드
        CoreDataManager.shared.clearAllObjectEntity("VinylBox")

        //when
        for i in 1...502 {
            dispatchGroup.enter()
            CoreDataManager.shared.saveVinylBoxWithDispatchGroup(vinylIndex: Int32(i), songTitle: "\(i)", singer: "test", vinylImage: (UIImage(named: "testdog")?.jpegData(compressionQuality: 0))!, dispatchGroup: dispatchGroup)
        }
        dispatchGroup.notify(queue: .global()) {
            viewModel.updateVinylBoxesAndReversBoxes()
            //then
            XCTAssertEqual(502, viewModel.getTotalVinylBoxCount())
            XCTAssertEqual(56, viewModel.totalPageNumber)
            var testVinylBoxItems = viewModel.getPagingVinylBoxItems(indexPath: [0,55])
            XCTAssertEqual("1", testVinylBoxItems[6].songTitle)
            testVinylBoxItems = viewModel.getPagingVinylBoxItems(indexPath: [0,3])
            XCTAssertEqual("474", testVinylBoxItems[1].songTitle)
            //특정페이지 songTitle로 맞는 데이터들어간지 확인
        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            testVinylBoxViewModel()
        }
    }

}
