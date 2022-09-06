//
//  NetworkError.swift
//  Vinyla
//
//  Created by IJ . on 2022/02/02.
//

import Foundation
import Moya

extension Moya.Response {
    
    var vinylaErrorModel: VinylaErrorModel? {
        guard let decodedData = try? JSONDecoder().decode(VinylaErrorModel.self, from: self.data) else { return nil }
        return decodedData
    }
    
}

enum NetworkError: Error {
    case nonExistentVinylaUser
    case requestDataError
    case serverError
    case unexpectedError
    case alreadyExistedVinylError
}

struct VinylaErrorModel: Codable {
    let status: Int
    let success: Bool
    let message: String
}

extension VinylaErrorModel {
    var vinylaError: NetworkError? {
        switch self.status {
        case 204: return NetworkError.nonExistentVinylaUser
        case 200..<300: return nil
        case 409: return NetworkError.alreadyExistedVinylError
        case 400..<500: return NetworkError.requestDataError
        case 500...600: return NetworkError.serverError
        default: return NetworkError.unexpectedError
        }
    }
}
