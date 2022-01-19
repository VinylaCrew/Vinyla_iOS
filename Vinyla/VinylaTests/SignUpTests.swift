//
//  SignUpTests.swift
//  VinylaTests
//
//  Created by IJ . on 2022/01/19.
//

import XCTest
@testable import Vinyla

class SignUpTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }



    func testSignUpCase1() throws {
        let testViewModel = SignUpViewModel(signUpAPIService: VinylAPIService())

        let testValue1 = testViewModel.isValidNickName("jj")
        let testValue2 = testViewModel.isValidNickName("Testㄱㄴ")

        XCTAssertEqual(testValue1, 1)
        XCTAssertEqual(testValue2, 3)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
