//
//  SignUpModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/27.
//

import Foundation

struct SignUpRequest: Encodable {
    var fuid: String?
    var sns: String
    var nickname: String
    var instaId: String
    var fcmToken: String
    var subscribeAgreed: Int
}

struct SignUpResponse: Decodable {
    struct Data: Decodable {
        let token, nickname: String
        let subscribeAgreed: Int
    }
    let status: Int
    let success: Bool
    let message: String
    let data: Data?
}
