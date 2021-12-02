//
//  GetMyVinylBoxDataTest.swift
//  VinylaTests
//
//  Created by IJ . on 2021/12/02.
//

import XCTest
@testable import Vinyla

class GetMyVinylBoxDataTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testGetMyVinylBoxData() {
        let testMockAPIService = MockAPIService()
        let mockSampleData = APITarget.getVinylBoxMyData.sampleData
        let expectedData = try? JSONDecoder().decode(MyVinylBoxModel.self, from: mockSampleData)

        testMockAPIService.getVinylBoxMyData()
            .subscribe(onNext:{ data in
                XCTAssertEqual(expectedData?.data?.userIdx, data?.userIdx)
                XCTAssertEqual(expectedData?.data?.myVinyls[0]?.imageURL, data?.myVinyls[0]?.imageURL)
                XCTAssertEqual(expectedData?.data?.myVinyls[1]?.title, data?.myVinyls[1]?.title)

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
