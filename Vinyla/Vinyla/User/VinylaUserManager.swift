//
//  VinylaUserManager.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/30.
//

import Foundation

final class VinylaUserManager {
    
    @UserDefault(key: UserDefaultsKey.vinylaToken)
    static var vinylaToken: String?
    
    @UserDefault(key: UserDefaultsKey.fcmToken)
    static var fcmToken: String?
    
    @UserDefault(key: UserDefaultsKey.userNickName)
    static var nickname: String?
    
    @UserDefault(key: UserDefaultsKey.initIsFirstLogIn)
    static var isFirstLogin: Bool?
    
    @UserDefault(key: UserDefaultsKey.myVinylIndex)
    static var myVInylIndex: Int?
    
    @UserDefault(key: UserDefaultsKey.firebaseUID)
    static var firebaseUID: String?
    
    @UserDefault(key: UserDefaultsKey.loginCase)
    static var loginSNSCase: String?
    
    @UserDefault(key: UserDefaultsKey.appVersionOfLastRun)
    static var appVersion: String?
    
    @UserDefault(key: UserDefaultsKey.explainHomeButton)
    static var explainHomeButton: Bool?
    
    @UserDefault(key: UserDefaultsKey.explainInstagramShare)
    static var explainInstagramShare: Bool?
    
    @UserDefault(key: UserDefaultsKey.eventSubscribeAgreed)
    static var eventSubscribeAgreed: Bool?
    
    @UserDefault(key: UserDefaultsKey.userVinylIndex)
    static var userVinylIndex: Int?
    
    static var hasToken: Bool {
        return VinylaUserManager.vinylaToken != nil
    }
    
    /// Firebase Auth
    @UserDefault(key: UserDefaultsKey.googleAccessToken)
    static var googleAccessToken: String?
    
    @UserDefault(key: UserDefaultsKey.googleIdToken)
    static var googleIdToken: String?
    
    @UserDefault(key: UserDefaultsKey.appleIdToken)
    static var appleIdToken: String?
    
    @UserDefault(key: UserDefaultsKey.appleNonce)
    static var appleNonce: String?
    
    static func clearAllUserSetting() {
        //fcmToken은 nil 처리하면 안됨, 앱실행시 한번 호출 되므로
        self.vinylaToken = nil
        self.nickname = nil
        self.isFirstLogin = nil
        self.myVInylIndex = nil
        self.firebaseUID = nil
        self.loginSNSCase = nil
        self.eventSubscribeAgreed = nil
        self.userVinylIndex = 0
        
        self.googleAccessToken = nil
        self.googleIdToken = nil
        self.appleIdToken = nil
        self.appleNonce = nil
    }
}
