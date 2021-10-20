//
//  VinylaSearchTests.swift
//  VinylaTests
//
//  Created by IJ . on 2021/10/21.
//

import XCTest
@testable import Vinyla

class VinylaSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchAPI() {
        //given
        let testAPIService = VinylAPIService()

        let expectation = XCTestExpectation()

        let expectedData = APITarget.vinylSearch(urlParameters: "test").sampleData

        //when
        testAPIService.testSearchVinyl(vinylName: "asdf")
            .subscribe(onNext: { data in
//                XCTAssertEqual(expectedData, data)
                expectation.fulfill()
            })
            .dispose()

        wait(for: [expectation], timeout: 2.0)


        //then

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
