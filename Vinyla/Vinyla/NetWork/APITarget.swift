//
//  APITarget.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/27.
//
import Foundation
import Moya

enum APITarget: TargetType {
    //MARK: - User API
    case signinUser(userToken: SignInRequest)
    case createUser(userData: SignUpRequest)
    case checkNickName(body: NickNameCheckRequest)
    case changeMarketingSubscribed(subscribed: MarketingSubscribedRequest)
    //MARK: - Vinyla APP Logic API
    case vinylSearch(urlParameters: String?)
    case getVinylDetail(pathVinylID: Int?)
    case getVinylBoxMyData
    case saveVinyl(vinylData: RequestSaveVinylModel)
    case deleteVinyl(vinylID: Int)
    case registerMyVinyl(vinylData: MyVinylRequest)
    case checkHomeInformation
    //MARK: - UPload User Vinyl
    case uploadUserVinyl(userVinylData: UploadUserVinylModel)
    

    var baseURL: URL {
        return URL(string:ServerHost.develop)!
    }

    var path: String {
        switch self {
        case .signinUser:
            return "/users/signin"
        case .createUser:
            return "/users/signup"
        case .checkNickName:
            return "/users/check"
        case .changeMarketingSubscribed:
            return "/users/mypage/notice"
        case .vinylSearch:
            return "/vinyls/search"
        case let .getVinylDetail(pathVinylID): //Path Variable
            return "/vinyls/search/" + String(pathVinylID ?? -1)
        case .getVinylBoxMyData:
            return "/vinyls/my"
        case .saveVinyl:
            return "/vinyls"
        case let .deleteVinyl(vinylID):
            return "/vinyls/" + String(vinylID)
        case .registerMyVinyl:
            return "/vinyls/rep"
        case .checkHomeInformation:
            return "/vinyls/home"
        case .uploadUserVinyl:
            return "/requests"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signinUser:
            return .post
        case .createUser:
            return .post
        case .checkNickName:
            return .post
        case .changeMarketingSubscribed:
            return .patch
        case .vinylSearch:
            return .get
        case .getVinylDetail:
            return .get
        case .getVinylBoxMyData:
            return .get
        case .saveVinyl:
            return .post
        case .deleteVinyl:
            return .delete
        case .registerMyVinyl:
            return .post
        case .checkHomeInformation:
            return .get
        case .uploadUserVinyl:
            return .post
        }
    }

    var sampleData: Data {
        switch self {
        case .vinylSearch(_):
//            return "[{\"name\": \"\(String(describing: urlParameters))\"}]".data(using: .utf8)!
            return responseJSON("SearchMockData")
        case .getVinylDetail(_):
            return responseJSON("VinylDetailMockData")
        case .getVinylBoxMyData:
            return responseJSON("VinylBoxMockData")
        default:
            return .init()
        }
    }

    var task: Task {
        switch self {
        case let .signinUser(userToken):
            guard let encodedData = try? JSONEncoder().encode(userToken) else { return .requestData(Data()) }
            return .requestData(encodedData)
        case let .createUser(userData):
            guard let encodedData = try? JSONEncoder().encode(userData) else { return .requestData(Data()) }
            return .requestData(encodedData)
        case let .checkNickName(nickName):
            guard let encodedData = try? JSONEncoder().encode(nickName) else { return .requestData(Data()) }
            return .requestData(encodedData)
        case let .changeMarketingSubscribed(subscribed):
            guard let encodedData = try? JSONEncoder().encode(subscribed) else { return .requestData(Data())}
            return .requestData(encodedData)
        case let .vinylSearch(urlParameters):
            if let vinylName = urlParameters {
                return .requestParameters(parameters: ["q" : vinylName], encoding: URLEncoding.default)
            }
            print("Vinyl Name Error")
            return .requestParameters(parameters: ["q" : "error"], encoding: URLEncoding.default)
        case .getVinylDetail(_):
            return .requestPlain
        case .getVinylBoxMyData:
            return .requestPlain
        case let .saveVinyl(vinylData):
            guard let encodedData = try? JSONEncoder().encode(vinylData) else { return .requestData(Data()) }
            return .requestData(encodedData)
        case .deleteVinyl:
            return .requestPlain
        case let .registerMyVinyl(vinylData):
            guard let encodedData = try? JSONEncoder().encode(vinylData) else { return .requestData(Data()) }
            return .requestData(encodedData)
        case .checkHomeInformation:
            return .requestPlain
        case let .uploadUserVinyl(userVinylData):
            let imageData = userVinylData.image
            let artistData = "\(userVinylData.artist)".data(using: String.Encoding.utf8) ?? Data()
            let titleData = "\(userVinylData.title)".data(using: String.Encoding.utf8) ?? Data()
            let memoData = "\(userVinylData.memo)".data(using: String.Encoding.utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData), name: "image", fileName: "user_vinyl.png", mimeType: "image/jpeg")]
            formData.append(Moya.MultipartFormData(provider: .data(artistData), name: "artist"))
            formData.append(Moya.MultipartFormData(provider: .data(titleData), name: "title"))
            formData.append(Moya.MultipartFormData(provider: .data(memoData), name: "memo"))
            return .uploadMultipart(formData)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .vinylSearch(_), .getVinylDetail(_), .getVinylBoxMyData, .saveVinyl, .deleteVinyl, .registerMyVinyl, .checkHomeInformation, .changeMarketingSubscribed:
            return ["Content-Type" : "application/json", "token" : VinylaUserManager.vinylaToken ?? ""]
        case .uploadUserVinyl:
            return ["Content-Type" : "multipart/form-data", "token" : VinylaUserManager.vinylaToken ?? ""]
        default: return ["Content-Type" : "application/json"]
        }
    }
}

func responseJSON(_ fileName: String) -> Data! {
    @objc class BundleIdentifierClass: NSObject {}

    let bundle = Bundle(for: BundleIdentifierClass.self)
    let path = bundle.path(forResource: fileName, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
