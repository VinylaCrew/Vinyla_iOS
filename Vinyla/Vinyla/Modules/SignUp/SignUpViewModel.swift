//
//  SignUpViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/28.
//

import Foundation

protocol SignUpViewModelProtocol {
    func setNickNameModel(nickName : String)
    func setInstaGramID(instaGramID : String)
}

final class SignUpViewModel: SignUpViewModelProtocol {
    var signUpModel = SignUpModel()
    
    func setNickNameModel(nickName : String) {
        self.signUpModel.nickName = nickName
        print(self.signUpModel.nickName)
    }
    
    func setInstaGramID(instaGramID : String) {
        self.signUpModel.instagramID = instaGramID
        print(self.signUpModel.instagramID)
    }
}

// Test ViewModel 만들때
//final class MockSignUpViewModel: SignUpViewModelProtocol {
//    var storage: String?
//    func setNickNameModel(nickName: String) {
//        storage = "asdf"
//    }
//}
