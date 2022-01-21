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

    }

    func testSearchAPI() {
        //mock data를 통한 MockAPIService test code

        //given
        let testAPIService = MockAPIService()

        let expectation = XCTestExpectation()

        let mockSampleData = APITarget.vinylSearch(urlParameters: "IU").sampleData

        let expectedResponseData = try? JSONDecoder().decode(SearchModel.self,from: mockSampleData)

        //when
        testAPIService.requestSearchVinyl(vinylName: "IU")
            .subscribe(onNext: { data in

                //then
                XCTAssertNotNil(data)
                print("Xcttest", data)
                XCTAssertEqual(expectedResponseData?.data[0]?.artist, data[0]?.artist)
                XCTAssertEqual(expectedResponseData?.data[2]?.title, data[2]?.title)
                //sample data가 decoding 되지 않아서 빈배열이 내려와서, 올바른 형식으로 json수정

                expectation.fulfill()
            }, onError: { error in
                print(error.localizedDescription)
            })

        wait(for: [expectation], timeout: 2.0)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
