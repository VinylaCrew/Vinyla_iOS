//
//  SignUpViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/28.
//

import Foundation
import RxSwift

protocol SignUpViewModelProtocol {
    var nickNameText: PublishSubject<String> { get }
    var isValidNickNameNumberSubject: BehaviorSubject<Int> { get }
    var validNickNameNumberSubject: PublishSubject<Int> { get }
    var isValidNickNameNumber: Int? { get }
    func isValidNickName(_ nickNameText: String) -> Int
    func checkString(text:String) -> Bool
}

final class SignUpViewModel: SignUpViewModelProtocol {
    //input
    private(set) var nickNameText: PublishSubject<String> = PublishSubject<String>()
    private(set) var isValidNickNameNumberSubject = BehaviorSubject<Int>(value: -5)
    //output
    private(set) var validNickNameNumberSubject = PublishSubject<Int>()
    public private(set) var isValidNickNameNumber: Int? = -1
    var signUpModel = SignUpModel()
    var disposeBag = DisposeBag()

    init() {
        // input textfield text를 , 유효한 닉네임인지 검사해서 Int값으로 Output 출력 바인딩
        _ = nickNameText.map{ [unowned self] text in
            return self.isValidNickName(text)
        }
        .bind(to: validNickNameNumberSubject)
        .disposed(by: disposeBag)

    }
    deinit {
        print("SignUpViewModel deinit")
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
