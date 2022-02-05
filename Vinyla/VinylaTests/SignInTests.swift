//
//  SignInTests.swift
//  VinylaTests
//
//  Created by IJ . on 2022/02/04.
//

import XCTest
@testable import Vinyla
import RxSwift

class SignInTests: XCTestCase {

    var disposeBag: DisposeBag!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
        expectation = XCTestExpectation(description: "SignInAPITest")
    }
    func testSignInSuccessCase() {
        let signinAPI = APITarget.signinUser(userToken: SignInRequest(fuid: "test151515", fcmToken: "123456"))

        CommonNetworkManager.request(apiType: signinAPI)
            .subscribe(onSuccess:{ [weak self] (response: SignInResponse) in
                XCTAssertNotNil(response)
                self?.expectation.fulfill()
            },onError: { [weak self] error in
                print("success error",error)
                self?.expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)
    }

    func testSignInFailureCase() {
        let signinAPI = APITarget.signinUser(userToken: SignInRequest(fuid: "", fcmToken: ""))

        CommonNetworkManager.request(apiType: signinAPI)
            .subscribe(onSuccess:{ [weak self] (response: SignInResponse) in
                self?.expectation.fulfill()
            },onError: { error in
                XCTAssertEqual(error as? NetworkError, NetworkError.requestDataError)
                self.expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
