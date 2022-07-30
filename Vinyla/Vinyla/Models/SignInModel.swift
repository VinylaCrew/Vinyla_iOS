//
//  SignInModel.swift
//  Vinyla
//
//  Created by IJ . on 2022/02/04.
//

import Foundation

struct SignInRequest: Encodable {
    let fuid: String
    let fcmToken: String
}

struct SignInResponse: Decodable {
    struct Data: Codable {
        let token: String
        let nickname: String
        let subscribeAgreed: Int
    }
    let data: Data?
}

