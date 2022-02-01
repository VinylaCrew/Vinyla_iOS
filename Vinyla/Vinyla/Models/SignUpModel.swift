//
//  SignUpModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/27.
//

import Foundation

struct SignUpRequest: Encodable {
    let fuid: String?
    let sns: String
    let nickname: String
    let instaId: String
    let fcmToken: String
    let subscribeAgreed: Int
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
