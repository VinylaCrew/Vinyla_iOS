//
//  WithdrawViewModel.swift
//  Vinyla
//
//  Created by Zio.H on 2022/05/07.
//

import Foundation
import Firebase

import RxSwift

final class WithdrawViewModel {
    
    private let credential: AuthCredential
    
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
    
    func withdrawVinylaUser() {
        let user = Auth.auth().currentUser
        
        user?.reauthenticate(with: credential) { result, error in
          if let error = error {
            // An error happened.
          } else {
            // User re-authenticated.
              user?.delete(completion: { error in
                  
                  if let error = error {
                      print("회원 탈퇴 실패")
                      return
                  }
                  
                  self.isDoneWithdraw.onNext(true)
                  
              })
          }
        }
    }
    
    func clearUserData() {
        VinylaUserManager.clearAllUserSetting()
        VinylaUserManager.myVInylIndex = -1
        CoreDataManager.shared.clearAllObjectEntity("MyImage")
        CoreDataManager.shared.clearAllObjectEntity("VinylBox")
    }
}
