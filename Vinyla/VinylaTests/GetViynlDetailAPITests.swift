//
//  GetViynlDetailAPITests.swift
//  VinylaTests
//
//  Created by IJ . on 2021/10/22.
//

import XCTest
@testable import Vinyla
import RxSwift

class GetViynlDetailAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testGetViynlDetailAPI() {
        let testMockAPIService = MockAPIService()

        let mockSampleData = APITarget.getVinylDetail(pathVinylID: 1234).sampleData

        let expectedResponseData = try? JSONDecoder().decode(VinylInformation.self,from: mockSampleData)

        testMockAPIService.getVinylDetail(vinylID: 12345)
            .timeout(DispatchTimeInterval.seconds(2), scheduler: MainScheduler.instance) //2초 동안 event 발생하지 않을씨 에러방출
            .subscribe(onNext: { data in
                XCTAssertEqual(expectedResponseData?.data?.artist, data?.artist)
                XCTAssertEqual(expectedResponseData?.data?.tracklist?[0], data?.tracklist?[0])

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
