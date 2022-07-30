//
//  UserDefaultsKey.swift
//  Vinyla
//
//  Created by IJ . on 2022/02/06.
//

import Foundation

struct UserDefaultsKey {
    static let vinylaToken = "VinylaToken"
    static let initIsFirstLogIn = "IsFirstLogin"
    static let userNickName = "UserNickName"
    static let myVinylIndex = "MyVinylIndex"
    static let firebaseUID = "firebaseUID"
    static let loginCase = "loginCase"
    static let fcmToken = "FCMToken"
    static let appVersionOfLastRun = "AppVersionOfLastRun"
    static let explainHomeButton = "ExplainHomeButton"
    static let explainInstagramShare = "ExplainInstagramShare"
    static let bundleShortVersionString = "CFBundleShortVersionString"
    static let eventSubscribeAgreed = "EventSubscribeAgreed"
    static let userVinylIndex = "UserVinylIndex"
    
    /// AppStore Review
    static let appStoreReviewDate = "AppStoreReviewDate"
    
    /// Firebase Auth Key
    static let googleAccessToken = "GoogleAccessToken"
    static let googleIdToken = "GoogleIdToken"
    static let appleIdToken = "AppleIdToekn"
    static let appleNonce = "AppleNonce"
}
