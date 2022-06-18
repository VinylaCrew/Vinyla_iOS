//
//  SignUpViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/28.
//

import Foundation
import RxSwift
import Firebase

protocol SignUpViewModelProtocol {
    var nicknameText: PublishSubject<String> { get }
    var instagramIDText: BehaviorSubject<String> { get }
    var validNickNameNumberSubject: PublishSubject<Int> { get }
    var isValidNickNameNumber: Int? { get }
    var checkNickNameNumberSubject: PublishSubject<Int> { get }
    var isCompletedCreateUserRequest: PublishSubject<Bool> { get }
    var isAllowMarketing: BehaviorSubject<Int> { get }
    
    func isValidNickName(_ nickNameText: String) -> Int
    func requestCreateUser() -> Void
}

final class SignUpViewModel: SignUpViewModelProtocol {
    //input
    private(set) var nicknameText: PublishSubject<String> = PublishSubject<String>()
    private(set) var instagramIDText: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    private(set) var isAllowMarketing: BehaviorSubject<Int> = BehaviorSubject<Int>(value: -1)
    //output
    private(set) var validNickNameNumberSubject = PublishSubject<Int>()
    private(set) var isUniqueNickNameSubject = PublishSubject<Int>()
    private(set) var checkNickNameNumberSubject = PublishSubject<Int>()
    private(set) var isCompletedCreateUserRequest = PublishSubject<Bool>()
    public private(set) var isValidNickNameNumber: Int? = -1
    private(set) var userNickName: String?

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
            //            .filter{ $0.count >= 2}
            //            .filter{ self.isValidNickName($0) == 1}
            .flatMapLatest{ [unowned self] userNickname -> Observable<NickNameCheckResponse.Data?> in
                let nickNameCheckRequest = NickNameCheckRequest(nickname: userNickname)
                print("signUpAPIService.checkNickName")
                return self.signUpAPIService.requestCheckNickName(requestModel: nickNameCheckRequest)
            }
            .subscribe(onNext:{ [weak self] data in
                if let data = data {
                    print(data)
                    self?.userNickName = data.nickname
                    self?.isUniqueNickNameSubject.onNext(1)
                }else {
                    //닉네임 중복
                    //                    self?.validNickNameNumberSubject.onNext(4)
                    self?.isUniqueNickNameSubject.onNext(4)
                    self?.isValidNickNameNumber = 4
                }
            })
            .disposed(by: disposeBag)

        _ = Observable.zip(validNickNameNumberSubject,isUniqueNickNameSubject)
            .subscribe(onNext:{ [weak self] (a,b) in
                print("zip test: validNickNameNumberSubject\(a) 서버통신Subject \(b)")
                if a == 2 {
                    self?.checkNickNameNumberSubject.onNext(a)
                }else if a == 3 && b == 4 {
                    self?.checkNickNameNumberSubject.onNext(a)
                }else if b == 4 {
                    self?.checkNickNameNumberSubject.onNext(4)
                }else {
                    self?.checkNickNameNumberSubject.onNext(a)
                }
            })
            .disposed(by: disposeBag)
    }
    deinit {
        print("SignUpViewModel deinit")
    }

    func requestCreateUser() {
        guard let nickName = self.userNickName, let firebaseUid = Auth.auth().currentUser?.uid, let isAllowMarketing = try? self.isAllowMarketing.value() else {
            return
        }
        
        guard let fcmToken = VinylaUserManager.fcmToken else {
            print("fcmToken guard let error",VinylaUserManager.fcmToken)
            return
        }
        
        let userData = SignUpRequest(fuid: firebaseUid,
                                     sns: VinylaUserManager.loginSNSCase ?? "",
                                     nickname: nickName,
                                     instaId: "",
                                     fcmToken: fcmToken,
                                     subscribeAgreed: isAllowMarketing)

        let createUserAPI = APITarget.createUser(userData: userData)
        _ = CommonNetworkManager.request(apiType: createUserAPI)
            .subscribe(onSuccess: { [weak self] (response: SignUpResponse) in
                VinylaUserManager.vinylaToken = response.data?.token
                if let eventAgree = response.data?.subscribeAgreed, eventAgree == 1 {
                    VinylaUserManager.eventSubscribeAgreed = true
                } else {
                    VinylaUserManager.eventSubscribeAgreed = false
                }
                
                self?.isCompletedCreateUserRequest.onNext(true)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func isValidNickName(_ nickNameText: String) -> Int {

        let validDispatchGroup = DispatchGroup()
        let myQueue = DispatchQueue(label: "com.io.serial")

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
            //            let nickNameCheckRequest = NickNameCheckRequest(nickname: nickNameText)
            //            self.signUpAPIService.checkNickName(requestModel: nickNameCheckRequest)
            //                .subscribe(onNext:{ [weak self] data in
            //                    if data == nil {
            //                        self?.isValidNickNameNumber = 4
            //                        self?.validNickNameNumberSubject.onNext(4)
            //                    }
            //
            //                })
            //                .disposed(by: disposeBag)

        }

        self.isValidNickNameNumber = isValidNickNameValue

        return isValidNickNameValue
    }
    
}
