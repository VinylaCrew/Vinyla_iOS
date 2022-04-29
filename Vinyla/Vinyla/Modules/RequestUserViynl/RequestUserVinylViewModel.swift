//
//  RequestUserVinylViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/09/03.
//

import Foundation
import RxSwift


final class RequestUserVinylViewModel {
    
    //input
    var userAlbumName = BehaviorSubject<String>(value: "")
    var userArtistName = BehaviorSubject<String>(value: "")
    var userMemo = BehaviorSubject<String>(value: "")
    var userImage: Data?
    
    //output
    var errorMessage = PublishSubject<String>()
    var isUpload = BehaviorSubject<Bool>(value: false)
    
    var disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func requestUploadUserVinyl() {
        
        guard let title = try? userAlbumName.value(), let artist = try? userArtistName.value(), let memo = try? userMemo.value() else { return }
        guard let userVinylImage = self.userImage else { return }
        let userVinylData = UploadUserVinylModel(title: title, artist: artist, memo: memo, image: userVinylImage)
        let uploadVinylAPITarget = APITarget.uploadUserVinyl(userVinylData: userVinylData)
        CommonNetworkManager.request(apiType: uploadVinylAPITarget)
            .subscribe(onSuccess: { [weak self] (response: UploadUserVinylResponse) in
                if let _ = response.data {
                    self?.isUpload.onNext(true)
                }
            },onError:{ [weak self] error in
                self?.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
    }
}
