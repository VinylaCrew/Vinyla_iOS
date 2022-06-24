//
//  AddReviewViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift
import RxRelay

protocol AddReviewViewModelProtocol {
    //input
    var userRate: PublishSubject<Int> { get }
    var userCommnet: PublishSubject<String> { get }
}

final class AddReviewViewModel: AddReviewViewModelProtocol {
    var songRate: Double?
    var songRateCount: Int?
    //input
    var userRate: PublishSubject<Int> = PublishSubject<Int>()
    var userCommnet: PublishSubject<String> = PublishSubject<String>()
    //output
    var apiError = PublishRelay<NetworkError>()

    //model
    var model: RequestSaveVinylModel
    var thumbnailImage: String?
    var disposeBag = DisposeBag()
    init() {
        self.model = RequestSaveVinylModel.init(id: 0, title: "", artist: "", image: "", year: 0, genres: [], tracklist: [], rate: nil, comment: nil)

        _ = userRate.subscribe(onNext: { [weak self] rate in
            self?.model.rate = rate
        })
        .disposed(by: disposeBag)

        _ = userCommnet.subscribe(onNext:{ [weak self] commnet in
            self?.model.comment = commnet
        })
        .disposed(by: disposeBag)
    }

    func requestSaveVinylData(tthumbailVinylImageData: Data, reviewVCDispatchGroup: DispatchGroup) {
        if self.model.comment == "이 음반에 대해 감상평을 솔직하게 남겨주세요." {
            self.model.comment = nil
        }
        
        let saveViynlAPI = APITarget.saveVinyl(vinylData: self.model)
        
        CommonNetworkManager.request(apiType: saveViynlAPI)
            .subscribe(onSuccess: { [weak self] (response: ResponseSaveVinylModel) in
                print(response)

                if let vinylIndex = response.data?.vinylIdx {
                    DispatchQueue.global().async() {
                        /// 썸네일 이미지 비동기 통신 삭제
                        /// 로드된 이미지 데이터 넘겨서 코어데이터에 저장 하도록 변경, 비동기 통신 1개라도 더 줄이기 위해
                        ///
//                        guard let thumbnailImageURL = self?.thumbnailImage else { return }
//                        guard let insideImageURL = URL(string: thumbnailImageURL) else { return }
//                        let dataTask = URLSession.shared.dataTask(with: insideImageURL) { (data, result, error) in
//                            guard error == nil else {
//                                return
//                            }
//
//                            if let data = data, let vinylImage = UIImage(data: data) {
                                CoreDataManager.shared.saveVinylBoxWithDispatchGroup(
                                    vinylIndex: Int64(vinylIndex),
                                    vinylID: Int64((self?.model.id)!),
                                    songTitle: self?.model.title ?? "",
                                    singer: self?.model.artist ?? "",
                                    vinylImage: tthumbailVinylImageData,//vinylImage.jpegData(compressionQuality: 1)!,
                                    dispatchGroup: reviewVCDispatchGroup
                                )
//                            }
//                        }
//
//                        dataTask.resume()
                    }
                }

            },onError: { [weak self] error in
                guard let vinylNetworkError = error as? NetworkError else { return }
                self?.apiError.accept(vinylNetworkError)
            })
            .disposed(by: disposeBag)
    }
}
