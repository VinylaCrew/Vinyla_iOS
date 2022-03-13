//
//  AddReviewViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift

protocol AddReviewViewModelProtocol {
    //input
    var userRate: PublishSubject<Int> { get }
    var userCommnet: PublishSubject<String> { get }
}

final class AddReviewViewModel: AddReviewViewModelProtocol {
    //input
    var userRate: PublishSubject<Int> = PublishSubject<Int>()
    var userCommnet: PublishSubject<String> = PublishSubject<String>()
    //output

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

    func requestSaveVinylData(dispatchGroup: DispatchGroup) {
        let saveViynlAPI = APITarget.saveVinyl(vinylData: self.model)

        CommonNetworkManager.request(apiType: saveViynlAPI)
            .subscribe(onSuccess: { [weak self] (response: ResponseSaveVinylModel) in
                print(response)
                let checkSaveDispatchGroup = DispatchGroup()

                if let vinylIndex = response.data?.vinylIdx {
                    DispatchQueue.global().async() {
                        checkSaveDispatchGroup.enter()
                        guard let insideImageURL = URL(string: (self?.thumbnailImage)!) else { return }
                        let dataTask = URLSession.shared.dataTask(with: insideImageURL) { (data, result, error) in
                            guard error == nil else {
                                return
                            }

                            if let data = data, let vinylImage = UIImage(data: data) {
                                CoreDataManager.shared.saveVinylBoxWithDispatchGroup(vinylIndex: Int32(vinylIndex), vinylID: Int64((self?.model.id)!), songTitle: self?.model.title ?? "", singer: self?.model.artist ?? "", vinylImage: vinylImage.jpegData(compressionQuality: 1)!, dispatchGroup: checkSaveDispatchGroup)
                            }
                        }

                        dataTask.resume()
                    }
                }

                checkSaveDispatchGroup.notify(queue: .global()) {
                    dispatchGroup.leave()
                }
            })
            .disposed(by: disposeBag)
    }
}
