//
//  MockAPIService.swift
//  Vinyla
//
//  Created by IJ . on 2021/10/21.
//

import Moya
import RxSwift
import Foundation


final class MockAPIService: VinylAPIServiceProtocol {

    static let customEndpointClosure = { (target: APITarget) -> Endpoint in
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    private let provider: MoyaProvider<APITarget>

    init(provider: MoyaProvider<APITarget> = MoyaProvider<APITarget>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub, plugins: [NetworkLoggerPlugin()]) ) {
        self.provider = provider
    }

    func requestSearchVinyl(vinylName: String) -> Observable<[SearchModel.Data]?> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.vinylSearch(urlParameters: vinylName)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(SearchModel.self, from: response.data)
                        if let data = decodedData.data {
                            emitter.onNext(data)
                        }
                    }catch {
                        print("decode error message:",error)
                    }

                case .failure(let error):
                    emitter.onError(error)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func requestVinylDetail(vinylID: Int?) -> Observable<VinylInformation.Data?> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.getVinylDetail(pathVinylID: vinylID)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(VinylInformation.self, from: response.data)
                        emitter.onNext(decodedData.data)
                        emitter.onCompleted()
                    } catch {
                        print("decode error")
                        print(error.localizedDescription)
                        emitter.onError(error)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }

            }
            return Disposables.create()
        }
    }

    func requestVinylBoxMyData() -> Observable<MyVinylBoxModel.Data?> {
        return Observable.create() { [weak self] emiiter in
            self?.provider.request(.getVinylBoxMyData){ result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(MyVinylBoxModel.self, from: response.data)
                        emiiter.onNext(decodedData.data)
                        emiiter.onCompleted()
                    } catch {
                        print("decode error")
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    emiiter.onError(error)
                }
            }

            return Disposables.create()
        }
    }
    

}


