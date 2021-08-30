//
//  APITarget.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//
import Foundation
import Moya

enum APITarget: TargetType {
    case vinylSearch(urlParameters: String?)
    case getMovies(urlParameters: String?)

    var baseURL: URL {
        return URL(string:"https://connect-boxoffice.run.goorm.io/")!
    }

    var path: String {
        switch self {
        case .vinylSearch:
            return "/vinyls/search"
        case .getMovies:
            return "movies"
        }
    }

    var method: Moya.Method {
        switch self {
        case .vinylSearch:
            return .get
        case .getMovies:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .vinylSearch(let urlParameters):
            return "[{\"name\": \"\(String(describing: urlParameters))\"}]".data(using: .utf8)!
        default:
            return .init()
        }
    }

    var task: Task {
        switch self {
        case let .vinylSearch(urlParameters):
            if let vinylName = urlParameters {
                return .requestParameters(parameters: ["q" : vinylName], encoding: URLEncoding.default)
            }
            print("Vinyl Name Error")
            return .requestParameters(parameters: ["q" : "error"], encoding: URLEncoding.default)
        case let .getMovies(urlParameters):
            if let order = urlParameters {
                if order == "1" || order == "2" || order == "0" {
                    return .requestParameters(parameters: ["order_type" : Int(order)!], encoding: URLEncoding.default)
                }else {
                    return .requestParameters(parameters: ["order_type" : 0], encoding: URLEncoding.default)
                }
            }
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        default: return ["Content-Type": "application/json"]
        }
    }
}
