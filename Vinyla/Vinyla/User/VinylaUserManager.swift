//
//  VinylaUserManager.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/30.
//

import Foundation

class VinylaUserManager {
    
    @UserDefault(key: UserDefaultsKey.vinylaToken)
    static var vinylaToken: String?
    
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
    
    static var hasToken: Bool {
        return VinylaUserManager.vinylaToken != nil
    }
    
    static func clearAllUserSetting() {
        self.vinylaToken = nil
        self.nickname = nil
        self.isFirstLogin = nil
        self.myVInylIndex = nil
        self.firebaseUID = nil
        self.loginSNSCase = nil
    }
}
