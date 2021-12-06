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
    func searchVinyl(vinylName: String) -> Observable<[SearchModel.Data?]>
    func getVinylBoxMyData() -> Observable<MyVinylBoxModel.Data?>
    func getVinylDetail(vinylID: Int?) -> Observable<VinylInformation.Data?>
}

final class VinylAPIService: VinylAPIServiceProtocol {

    private let provider: MoyaProvider<APITarget>

    init(provider: MoyaProvider<APITarget> = MoyaProvider<APITarget>()) {
        self.provider = provider
    }

    func searchVinyl(vinylName: String) -> Observable<[SearchModel.Data?]> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.vinylSearch(urlParameters: vinylName)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(SearchModel.self, from: response.data)
//                        print("response data",response.data)
                        print("response data status,message:",decodedData.status,decodedData.message)
                        emitter.onNext(decodedData.data)
                    }catch {
                        print("decode error message:",error,response.data)
                        //토큰 안넣고 검색한경우 fail model 안맞아서 디코드 에러 발생
                        //검색에 아무것도 없는경우도 fail model처리
                        emitter.onNext([])//이전 검색결과값 지워짐
                    }

                case .failure(let error):
                    emitter.onError(error)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func getVinylBoxMyData() -> Observable<MyVinylBoxModel.Data?> {
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

    func getVinylDetail(vinylID: Int?) -> Observable<VinylInformation.Data?> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.getVinylDetail(pathVinylID: vinylID)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(VinylInformation.self, from: response.data)
                        emitter.onNext(decodedData.data)
                        print("getvinyl detail:",decodedData.message,decodedData.status)
                        emitter.onCompleted()

                    } catch {
                        print("get Vinyl Detail decode error")
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    emitter.onError(error)
                    print("dadada2")
                }

            }
            return Disposables.create()
        }
    }
}
