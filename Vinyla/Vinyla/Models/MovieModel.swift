//
//  Movies.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//

import Foundation

struct MovieModel: Codable {
    struct Data: Codable {
        let title: String?
        let reservationGrade: Int?
        let thumb: String?
        let id: String?
        let reservationRate: Double?
        let userRating: Double?
        let grade: Int?
        let date: String?

        enum CodingKeys: String, CodingKey {
            case title
            case reservationGrade = "reservation_grade"
            case thumb, id
            case reservationRate = "reservation_rate"
            case userRating = "user_rating"
            case grade, date
        }
    }
    let orderType: Int?
    let movies: [Data?]

    init() {
        self.orderType = 0
        self.movies = [Data]()
    }
    enum CodingKeys: String, CodingKey {
        case orderType = "order_type"
        case movies
    }
}


