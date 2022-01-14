//
//  SignUpViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/28.
//

import Foundation
import RxSwift

protocol SignUpViewModelProtocol {
    var nicknameText: PublishSubject<String> { get }
    var isValidNickNameNumberSubject: BehaviorSubject<Int> { get }
    var validNickNameNumberSubject: PublishSubject<Int> { get }
    var isValidNickNameNumber: Int? { get }
    func isValidNickName(_ nickNameText: String) -> Int
}

final class SignUpViewModel: SignUpViewModelProtocol {
    //input
    private(set) var nicknameText: PublishSubject<String> = PublishSubject<String>()
    private(set) var isValidNickNameNumberSubject = BehaviorSubject<Int>(value: -5)
    //output
    private(set) var validNickNameNumberSubject = PublishSubject<Int>()
    public private(set) var isValidNickNameNumber: Int? = -1
    var signUpAPIService: VinylAPIService
    var disposeBag = DisposeBag()

    init(signUpAPIService: VinylAPIService = VinylAPIService()) {
        self.signUpAPIService = signUpAPIService
        
        // input textfield text를 , 유효한 닉네임인지 검사해서 Int값으로 Output 출력 바인딩
        _ = nicknameText.map{ [unowned self] text in
            return self.isValidNickName(text)
        }
        .bind(to: validNickNameNumberSubject)
        .disposed(by: disposeBag)


        // Server Nickname 중복검사
        _ = self.nicknameText
            .filter{ $0.count >= 2}
            .filter{ self.isValidNickName($0) == 1}
            .flatMapLatest{ [unowned self] userNickname -> Observable<NickNameCheckResponse.Data?> in
                let nickNameCheckRequest = NickNameCheckRequest(nickname: userNickname)
                print("signUpAPIService.checkNickName")
                return self.signUpAPIService.checkNickName(requestModel: nickNameCheckRequest)
            }
            .subscribe(onNext:{ data in
                if let data = data {
                    print(data)
                }else {
                    self.validNickNameNumberSubject.onNext(4)
                }
            })
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

        self.isValidNickNameNumber = isValidNickNameValue

        return isValidNickNameValue
    }
}
