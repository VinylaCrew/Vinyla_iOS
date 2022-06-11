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
    func requestSearchVinyl(vinylName: String) -> Observable<[SearchModel.Data]?>
    func requestVinylBoxMyData() -> Observable<MyVinylBoxModel.Data?>
    func requestVinylDetail(vinylID: Int?) -> Observable<VinylInformation.Data?>
}

final class VinylAPIService: VinylAPIServiceProtocol {

    private let provider: MoyaProvider<APITarget>

    init(provider: MoyaProvider<APITarget> = MoyaProvider<APITarget>()) {
        self.provider = provider
    }

    func requestCheckNickName(requestModel: NickNameCheckRequest) -> Observable<NickNameCheckResponse.Data?> {
        return Observable.create() { [weak self] observer in
            self?.provider.request(.checkNickName(body: requestModel)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(NickNameCheckResponse.self, from: response.data)
                        observer.onNext(decodedData.data)
//                        observer.onCompleted()
                    } catch {
                        print("nickname response decode error message:",error,response.data)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()

            }
            return Disposables.create()
        }
    }

    func requestSearchVinyl(vinylName: String) -> Observable<[SearchModel.Data]?> {

        return Observable.create() { [weak self] emitter in
            self?.provider.request(.vinylSearch(urlParameters: vinylName)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(SearchModel.self, from: response.data)
                        print("response data status,message:",decodedData.status,decodedData.message,decodedData.data)
                        if let data = decodedData.data {
                            emitter.onNext(data)
                        }else {
                            print("response data가 없는 경우 [] 호출")
                            emitter.onNext([])
                        }
                    }catch {
                        print("decode error message:",error)
                        //토큰 안넣고 검색한경우 fail model 안맞아서 디코드 에러 발생
                        //Data 옵셔널 처리로 인한 decoding fail
                    }

                case .failure(let error):
                    emitter.onError(error)
                }
                emitter.onCompleted()
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

    func requestVinylDetail(vinylID: Int?) -> Observable<VinylInformation.Data?> {

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
