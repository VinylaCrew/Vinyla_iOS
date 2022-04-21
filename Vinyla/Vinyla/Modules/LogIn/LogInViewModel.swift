//
//  LogInViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift

final class LogInViewModel {

    var disposeBag = DisposeBag()

    init() {
//                var list: [Int]? = [1, 2, 3]
//                var list2: [Int?] = [1, 2, 3]
//                list = nil
//                list2 = nil
//                print(list)
//                print(list2)
        
//        let searchAPI = APITarget.vinylSearch(urlParameters: "aa")
//
//        NetworkManager.shared.request(apiType: searchAPI)
//            .subscribe(onSuccess: { (responseData: SearchModel) in
//
//                if let data = responseData.data {
//                    print(data)
//                }
//            })
//            .disposed(by: disposeBag)

//        let searchAPI = APITarget.vinylSearch(urlParameters: "aa")
//
//        NetworkManager.request(apiType: searchAPI)
//            .subscribe(onSuccess: { (responseData: SearchModel) in
//                if let data = responseData.data {
//                    print(data)
//                }
//            })
//            .disposed(by: disposeBag)



    }

    func test() {
        let checkAPI = APITarget.checkNickName(body: NickNameCheckRequest(nickname: "asd"))

            CommonNetworkManager.request(apiType: checkAPI)
                .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
                .subscribe(onSuccess: { (data: NickNameCheckResponse) in

                    print(data)
                })
                .disposed(by: disposeBag)

    }
}
