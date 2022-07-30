//
//  LogInViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import CryptoKit
import RxSwift

final class LogInViewModel {
    
    var currentNonce: String?
    
    var disposeBag = DisposeBag()
    

    init() {
//                var list: [Int]? = [1, 2, 3]
//                var list2: [Int?] = [1, 2, 3]
//                list = nil
//                list2 = nil
//                print(list)
//                print(list2)
        
//        let searchAPI = APITarget.vinylSearch(urlParameters: "aa")
//
//        NetworkManager.shared.request(apiType: searchAPI)
//            .subscribe(onSuccess: { (responseData: SearchModel) in
//
//                if let data = responseData.data {
//                    print(data)
//                }
//            })
//            .disposed(by: disposeBag)

//        let searchAPI = APITarget.vinylSearch(urlParameters: "aa")
//
//        NetworkManager.request(apiType: searchAPI)
//            .subscribe(onSuccess: { (responseData: SearchModel) in
//                if let data = responseData.data {
//                    print(data)
//                }
//            })
//            .disposed(by: disposeBag)



    }

    func test() {
        let checkAPI = APITarget.checkNickName(body: NickNameCheckRequest(nickname: "asd"))

            CommonNetworkManager.request(apiType: checkAPI)
                .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
                .subscribe(onSuccess: { (data: NickNameCheckResponse) in

                    print(data)
                })
                .disposed(by: disposeBag)

    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
