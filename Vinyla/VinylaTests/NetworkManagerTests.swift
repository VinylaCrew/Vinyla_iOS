//
//  NetworkManagerTests.swift
//  VinylaTests
//
//  Created by IJ . on 2022/01/24.
//

import XCTest
@testable import Vinyla
import RxSwift

class NetworkManagerTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testNetworkManager() {
        var expectation = XCTestExpectation(description: "NicknameServerAPI")
        var searchExpectation = XCTestExpectation(description: "SearchServerAPI")
        let nicknameAPI = APITarget.checkNickName(body: NickNameCheckRequest(nickname: "tes"))

        CommonNetworkManager.request(apiType: nicknameAPI)
            .subscribe(onSuccess: { (successModel: NickNameCheckResponse) in
                print(successModel.message)
                XCTAssertEqual(successModel.message,"사용 가능한 닉네임입니다.")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        let searchAPI = APITarget.vinylSearch(urlParameters: "hh")

        CommonNetworkManager.request(apiType: searchAPI)
            .subscribe(onSuccess: { (responseData: SearchModel) in
                print(responseData.message)
                XCTAssertEqual(responseData.message, "바이닐 검색 성공")
                XCTAssertNotNil(responseData.data)
                searchExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation,searchExpectation], timeout: 20)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
