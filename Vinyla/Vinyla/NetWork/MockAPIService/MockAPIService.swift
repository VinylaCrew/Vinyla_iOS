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

    func searchVinyl(vinylName: String) -> Observable<[SearchModel.Data?]> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.vinylSearch(urlParameters: vinylName)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(SearchModel.self, from: response.data)
                        emitter.onNext(decodedData.data)
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

    func getMovies(order: String) -> Observable<[MovieModel.Data?]> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.getMovies(urlParameters: order)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(MovieModel.self, from: response.data)
//                        print("APIService response.data", decodedData, response.data) // 통신성공 데이터 타입만 맞춰주면됨 [MovieModel] 아님
                        print("APIService2", decodedData.movies)
                        emitter.onNext(decodedData.movies)
                        emitter.onCompleted()
                    } catch {
                        print("decode error")
                        print(error.localizedDescription)
                    }

                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func getVinylDetail(vinylID: Int?) -> Observable<VinylInformation.Data?> {

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
                    }
                case .failure(let error):
                    emitter.onError(error)
                }

            }
            return Disposables.create()
        }
    }
    

}


