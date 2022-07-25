//
//  RequestUserVinylViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/09/03.
//

import Foundation
import RxSwift
import RxRelay


final class RequestUserVinylViewModel {
    
    //input
    var userAlbumName = BehaviorSubject<String>(value: "")
    var userArtistName = BehaviorSubject<String>(value: "")
    var userMemo = BehaviorSubject<String>(value: "")
    var userImage: Data?
    
    //output
    var apiError = PublishRelay<NetworkError>()
    var isUpload = BehaviorSubject<Bool>(value: false)
    
    var disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func requestUploadUserVinyl() {
        
        guard let title = try? userAlbumName.value(), let artist = try? userArtistName.value(), let memo = try? userMemo.value() else {
            self.apiError.accept(NetworkError.requestDataError)
            return
        }
        
        guard let userVinylImage = self.userImage else {
            self.apiError.accept(NetworkError.requestDataError)
            return
        }
        
        let userVinylData = UploadUserVinylModel(title: title, artist: artist, memo: memo, image: userVinylImage)
        let uploadVinylAPITarget = APITarget.uploadUserVinyl(userVinylData: userVinylData)
        
        CommonNetworkManager.request(apiType: uploadVinylAPITarget)
            .subscribe(onSuccess: { [weak self] (response: UploadUserVinylResponse) in
                if let _ = response.data {
                    self?.isUpload.onNext(true)
                }
            },onError:{ [weak self] error in
                
                guard let vinylNetworkError = error as? NetworkError else {
                    self?.apiError.accept(NetworkError.unexpectedError)
                    return
                }
                self?.apiError.accept(vinylNetworkError)
            })
            .disposed(by: disposeBag)
        
    }
}
