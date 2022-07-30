//
//  WithdrawViewModel.swift
//  Vinyla
//
//  Created by Zio.H on 2022/05/07.
//

import Foundation
import CryptoKit

import Firebase
import RxSwift
import GoogleSignIn

final class WithdrawViewModel {
    
    private(set) var credential: AuthCredential
    
    var currentNonce: String?
    
    /// Output
    let isDoneWithdraw = PublishSubject<Bool>()
    
    init() {
        
        if VinylaUserManager.loginSNSCase == "Google" {
            self.credential = GoogleAuthProvider.credential(
                withIDToken: VinylaUserManager.googleIdToken ?? "",
                accessToken: VinylaUserManager.googleAccessToken ?? ""
            )
        } else {
            self.credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: VinylaUserManager.appleIdToken ?? "",
                rawNonce: VinylaUserManager.appleNonce ?? ""
            )
        }
        
    }
    
    func withdrawVinylaUser22() {
        let user = Auth.auth().currentUser
        
        if VinylaUserManager.loginSNSCase == "Google" {
            
            //              재로그인하여 firebase reauth 탈퇴
//            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//            let signInConfig = GIDConfiguration.init(clientID: clientID)
//
//            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//                guard error == nil else { return }
//
//                guard let authentication = user?.authentication else { return }
//                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
//                // access token 부여 받음
//
//                guard let user = Auth.auth().currentUser else { return }
//                user.reauthenticate(with: credential) {_,_ in
//                    user.delete{ error in
//                        if let error = error {
//                            print(error)
//                        }else {
//                            print("user 삭제완료")
//                        }
//                    }
//                }
//
//            }
            
        } else {
            self.credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: VinylaUserManager.appleIdToken ?? "",
                rawNonce: self.randomNonceString()
            )
        }
        
//        user?.reauthenticate(with: credential) { result, error in
//          if let error = error {
//            // An error happened.
//              print(error)
//          } else {
//            // User re-authenticated.
//              user?.delete(completion: { error in
//
//                  if let error = error {
//                      print("회원 탈퇴 실패")
//                      return
//                  }
//
//                  self.isDoneWithdraw.onNext(true)
//
//              })
//          }
//        }
    }
    
    func clearUserData() {
        VinylaUserManager.clearAllUserSetting()
        VinylaUserManager.myVInylIndex = -1
        CoreDataManager.shared.clearAllObjectEntity("MyImage")
        CoreDataManager.shared.clearAllObjectEntity("VinylBox")
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
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
