//
//  SignUpModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/27.
//

import Foundation

struct SignUpModel {
    var nickName : String?
    var instagramID : String?
    var isAllowService : Bool?
    var isAllowPrivacy : Bool?
    var isAllowPushMarketingAlarm : Bool?
    
    private mutating func setNickName(nickName : String) {
        self.nickName = nickName
    }
    
    private mutating func setInstaGramID(instagramID : String) {
        self.instagramID = instagramID
    }
}
