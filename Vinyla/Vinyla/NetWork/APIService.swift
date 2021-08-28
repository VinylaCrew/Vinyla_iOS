//
//  APIService.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//

import Moya
import RxSwift
import Foundation

protocol VinylAPIServiceProtocol {
    func searchVinyl(vinylName: String) -> Observable<[SearchModel]>
    func getMovies(order: String) -> Observable<[MovieModel.Data?]>
}

final class VinylAPIService: VinylAPIServiceProtocol {

    private let provider: MoyaProvider<APITarget>

    init(provider: MoyaProvider<APITarget> = MoyaProvider<APITarget>()) {
        self.provider = provider
    }

    func searchVinyl(vinylName: String) -> Observable<[SearchModel]> {
        return Observable.create() { [weak self] emitter in
            self?.provider.request(.vinylSearch(urlParameters: vinylName)) { result in
                switch result {
                case .success(let response):
                    let decodedData = try? JSONDecoder().decode([SearchModel].self, from: response.data)
                    emitter.onNext(decodedData ?? [])
                case .failure(let error):
                    emitter.onError(error)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func getMovies(order: String) -> Observable<[MovieModel.Data?]> {

//        if order == "" { return Observable.create() { ob in
//            ob.onNext([])
//            ob.onCompleted()
//            return Disposables.create()
//        }
//        }
        return Observable.create() { [weak self] emitter in
            self?.provider.request(.getMovies(urlParameters: order)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(MovieModel.self, from: response.data)
//                        print("APIService", decodedData, response.data) // 통신성공 데이터 타입만 맞춰주면됨 [MovieModel] 아님
//                        print("APIService2", decodedData.movies)
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
}
