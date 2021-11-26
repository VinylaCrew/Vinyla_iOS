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
    case getVinylDetail(pathVinylID: Int?)

    var baseURL: URL {
        return URL(string:"http://13.209.245.76:3000")!

    }

    var path: String {
        switch self {
        case .vinylSearch:
            return "/vinyls/search"
        case .getMovies:
            return "movies"
        case let .getVinylDetail(pathVinylID)://Path Variable
            return "/vinyls/search/" + String(pathVinylID ?? -1)
        }
    }

    var method: Moya.Method {
        switch self {
        case .vinylSearch:
            return .get
        case .getMovies:
            return .get
        case .getVinylDetail:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .vinylSearch(_):
//            return "[{\"name\": \"\(String(describing: urlParameters))\"}]".data(using: .utf8)!
            return responseJSON("SearchMockData")
        case .getVinylDetail(_):
            return responseJSON("VinylDetailMockData")
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
        case .getVinylDetail(_):
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .vinylSearch(_):
            return ["Content-Type" : "application/json", "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHgiOjE3LCJpYXQiOjE2Mzc3Mzk1NjAsImV4cCI6MTYzNzc1NzU2MCwiaXNzIjoiaGFlbHkifQ.CBz8xUuF5YOpuZ6LuE9CdzDrbS2NYQzzQQSHihG4PkY"]
        case .getVinylDetail(_):
            return ["Content-Type" : "application/json", "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHgiOjE3LCJpYXQiOjE2Mzc3Mzk1NjAsImV4cCI6MTYzNzc1NzU2MCwiaXNzIjoiaGFlbHkifQ.CBz8xUuF5YOpuZ6LuE9CdzDrbS2NYQzzQQSHihG4PkY"]
        default: return ["Content-Type" : "application/json"]
        }
    }
}

func responseJSON(_ fileName: String) -> Data! {
    @objc class TestClass: NSObject {}

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: fileName, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
