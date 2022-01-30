//
//  SignUpTests.swift
//  VinylaTests
//
//  Created by IJ . on 2022/01/19.
//

import XCTest
@testable import Vinyla
import RxSwift

class SignUpTests: XCTestCase {

    var disposeBag = DisposeBag()
    var testViewModel: SignUpViewModel!

    override func setUpWithError() throws {
        testViewModel = SignUpViewModel(signUpAPIService: VinylAPIService())
    }

    func testCehckNickNameCase() throws {

        let testValue1 = testViewModel.isValidNickName("jj")
        let testValue2 = testViewModel.isValidNickName("Testㄱㄴ")

        let expectation = XCTestExpectation(description: "API Request")
        let nickNameRequest = NickNameCheckRequest(nickname: "test")

        _ = testViewModel.signUpAPIService.requestCheckNickName(requestModel: nickNameRequest)
            .subscribe(onNext: { data in
                if let data = data {
                    //닉네임 중복되지 않음
                    XCTAssertNotNil(data)
                }else {
                    //닉네임 중복
                    XCTAssertNil(data)
                }

                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        XCTAssertEqual(testValue1, 1)
        XCTAssertEqual(testValue2, 3)

        wait(for: [expectation], timeout: 10)

    }

    func testCreateUser() throws {
        let exceptation = XCTestExpectation(description: "SignUp Request")

        let requestData = SignUpRequest(fuid: "amsiejr", sns: "Google", nickname: "asdf5000",instaId: "abcd", fcmToken: "mwgpasifj", subscribeAgreed: 1)
        let createUserAPI = APITarget.createUser(userData: requestData)

        NetworkManager.request(apiType: createUserAPI)
            .subscribe(onSuccess: { (response: SignUpResponse) in
                print(response.message)
                print(response.data)
                XCTAssertEqual(response.message, "회원 가입 성공")
                exceptation.fulfill()
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)

        wait(for: [exceptation], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
