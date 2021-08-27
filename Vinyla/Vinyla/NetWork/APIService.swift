//
//  APIService.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//

import Moya
import RxSwift

protocol VinylAPIServiceProtocol {
    func searchVinyl(vinylName: String) -> Observable<[SearchModel]>
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

}
