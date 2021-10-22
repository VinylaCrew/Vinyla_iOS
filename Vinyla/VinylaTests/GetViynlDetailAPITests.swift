//
//  GetViynlDetailAPITests.swift
//  VinylaTests
//
//  Created by IJ . on 2021/10/22.
//

import XCTest
@testable import Vinyla

class GetViynlDetailAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testGetViynlDetailAPI() {
        let testMockAPIService = MockAPIService()

        let mockSampleData = APITarget.getVinylDetail(urlParameters: 1234).sampleData

        let expectedResponseData = try? JSONDecoder().decode(VinylInformation.self,from: mockSampleData)

        testMockAPIService.getVinylDetail(vinylID: 12345)
            .subscribe(onNext: { data in
                XCTAssertEqual(expectedResponseData?.data.artist, data?.artist)
                XCTAssertEqual(expectedResponseData?.data.tracklist[0].title, data?.tracklist[0].title)

                print(data)
            })
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
