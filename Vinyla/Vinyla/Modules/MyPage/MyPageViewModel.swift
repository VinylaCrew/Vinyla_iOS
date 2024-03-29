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
    let loginUserText = PublishSubject<String>()
    let loginUserImageName = PublishSubject<String>()
    let eventSubscribeAgreed = PublishSubject<Bool>()
    
    let appVersion: String? = {
        return VinylaUserManager.appVersion
    }()
    
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
            .subscribe(onSuccess: { [weak self] (response: VinylaErrorModel) in
                if response.success {
                    self?.marketingCompleteSubject.onNext(true)
                    VinylaUserManager.eventSubscribeAgreed = isSubscribeAgreed
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateUserLoginSNSCase() {
        if VinylaUserManager.loginSNSCase == "Google" {
            self.loginUserText.onNext("Google로 로그인")
            self.loginUserImageName.onNext("icnGoogle")
        }else if VinylaUserManager.loginSNSCase == "Apple" {
            self.loginUserText.onNext("Apple로 로그인")
            self.loginUserImageName.onNext("icnApple")
        }
    }
    
    func updateEventSubscribeAgreed() {
        if VinylaUserManager.eventSubscribeAgreed == true {
            self.eventSubscribeAgreed.onNext(true)
        } else {
            self.eventSubscribeAgreed.onNext(false)
        }
    }
}
