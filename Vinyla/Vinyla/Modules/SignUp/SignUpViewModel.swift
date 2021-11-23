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
    func isValidNickName(_ nickNameText: String) -> Int
    func checkString(text:String) -> Bool
}

final class SignUpViewModel: SignUpViewModelProtocol {

    var signUpModel = SignUpModel()
    
    func setNickNameModel(nickName : String) {
        self.signUpModel.nickName = nickName
//        print(self.signUpModel.nickName)
    }
    
    func setInstaGramID(instaGramID : String) {
        self.signUpModel.instagramID = instaGramID
//        print(self.signUpModel.instagramID)
    }
    
    func isValidNickName(_ nickNameText: String) -> Int {
        let checkArray = ["ㄱ","ㄴ","ㄷ","ㄹ","ㅁ","ㅂ","ㅅ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ","ㄲ","ㄸ","ㅃ","ㅆ","ㅉ","ㅏ","ㅑ","ㅓ","ㅕ","ㅗ","ㅛ","ㅜ","ㅠ","ㅡ","ㅣ","ㅐ","ㅒ","ㅔ","ㅖ","ㅘ","ㅙ","ㅚ","ㅝ","ㅞ","ㅟ","ㅢ"]
        var isValidNickName: Bool = true
        var isValidNickNameValue: Int
        for checkWord in checkArray {
            if nickNameText.contains(checkWord) {
                isValidNickName = false
            }
        }
        if isValidNickName == false {
            isValidNickNameValue = 3
        }else {
            isValidNickNameValue = 1
        }

        if nickNameText.count < 2 {
            isValidNickNameValue = 2
        }else if isValidNickNameValue == 3{
            isValidNickNameValue = 3
        }else {
            isValidNickNameValue = 1
        }

        if isValidNickNameValue == 1 {
            //통신해서 가능한 닉네임인지 아닌지 체크
        }
       return isValidNickNameValue
    }
    
    func checkString(text:String) -> Bool {
        // String -> Array
            let arr = Array(text)
            // 정규식 pattern. 한글, 영어, 숫자, 밑줄(_)만 있어야함
            let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9_]$"
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                    let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if results.count == 0 {
                        return false
                    } else {
                        index += 1
                    }
                }
            }
            return true
    }
}

// Test ViewModel 만들때
//final class MockSignUpViewModel: SignUpViewModelProtocol {
//    var storage: String?
//    func setNickNameModel(nickName: String) {
//        storage = "asdf"
//    }
//}
