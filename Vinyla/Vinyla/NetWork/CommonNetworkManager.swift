//
//  NetworkManager.swift
//  Vinyla
//
//  Created by IJ . on 2022/01/22.
//

import Foundation
import Moya
import RxSwift

class CommonNetworkManager {

    static func request<T: Decodable, U: TargetType>(provider: MoyaProvider<U> = MoyaProvider(),
                                                     apiType: U) -> Single<T> {
        return Single<T>.create { single in
            let request = provider.request(apiType) { result in
                switch result {
                case .success(let response):
                    self.printForDebug(apiType, response)
                    if let serverResponseError = response.vinylaErrorModel?.vinylaError {
                        print(serverResponseError)
                        single(.error(serverResponseError))
                        return
                    }
                    do {
                        guard let responseJsonDecodedData = try? JSONDecoder().decode(T.self, from: response.data) else {
                            throw NSError(domain: "JSON Parsing Error", code: -1, userInfo: nil)
                        }

                        single(.success(responseJsonDecodedData))
                    } catch let error {
                        single(.error(error))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }

            return Disposables.create { request.cancel() }
        }
    }

    private static func printForDebug(_ api: TargetType, _ response: Moya.Response) {
        #if DEBUG
        guard let mapJSONString = try? response.mapString() else { return }

        print("")
        print("----------------------------DEBUG MESSAGE----------------------------")
        print("REQUEST API : \(String(describing: api.self))")
        print("RESPONSE JSON : \(mapJSONString)")
        print("----------------------------DEBUG MESSAGE----------------------------")
        print("")
        #endif
    }
}

