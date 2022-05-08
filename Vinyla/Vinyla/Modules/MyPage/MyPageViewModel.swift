//
//  MyPageViewModel.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/28.
//

import Foundation
import RxSwift

final class MyPageViewModel {
    
    //input
    let marketingSubscribed = PublishSubject<Bool>()
    //output
    let marketingCompleteSubject = PublishSubject<Bool>()
    
    let disposeBag = DisposeBag()
    
    init() {
        
        self.marketingSubscribed
            .subscribe(onNext: { [weak self] value in
                self?.requestMarketingSubscribed(isSubscribeAgreed: value)
            })
            .disposed(by: disposeBag)
        
    }
    
    func clearUserData() {
        VinylaUserManager.clearAllUserSetting()
        VinylaUserManager.myVInylIndex = -1
        CoreDataManager.shared.clearAllObjectEntity("MyImage")
        CoreDataManager.shared.clearAllObjectEntity("VinylBox")
    }
    
    func requestMarketingSubscribed(isSubscribeAgreed: Bool) {
        let subscribedData = MarketingSubscribedRequest(subscribeAgreed: isSubscribeAgreed)
        let marketingAPITarget = APITarget.changeMarketingSubscribed(subscribed: subscribedData)
        CommonNetworkManager.request(apiType: marketingAPITarget)
            .subscribe(onSuccess: { (response: VinylaErrorModel) in
                if response.success {
                    self.marketingCompleteSubject.onNext(true)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
