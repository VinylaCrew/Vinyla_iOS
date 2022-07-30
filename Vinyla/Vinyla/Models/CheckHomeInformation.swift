//
//  CheckHomeInformation.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/23.
//

import Foundation

struct CheckHomeInformationResponse: Decodable {

    let data: DataStruct
}

struct DataStruct: Decodable {
    let myVinyl: Vinyl?
    let recentVinyls: [Vinyl]?
    let userInfo: [UserInformation]?
    let genreInfo: [String]?
}

struct Vinyl: Codable {
    let vinylIdx: Int
    let title: String
    let imageURL: String
    let artist: String
    let rate: Double
    let rateCount, id, year: Int

    enum CodingKeys: String, CodingKey {
        case vinylIdx, title
        case imageURL = "imageUrl"
        case artist, rate, rateCount, id, year
    }
}

struct UserInformation: Decodable {
    let userIdx: Int
    let fuid, sns, nickname, instaID: String
    let rankIdx, vinylNum: Int
    let fcmToken: String
    let subscribeAgreed: Int
    
    enum CodingKeys: String, CodingKey {
        case userIdx, fuid, sns, nickname
        case instaID = "instaId"
        case rankIdx, vinylNum, fcmToken, subscribeAgreed
    }
}
