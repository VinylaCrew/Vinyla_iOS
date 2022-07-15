//
//  LogInViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/06/27.
//

import UIKit

import Firebase
import GoogleSignIn
import AuthenticationServices
import RxSwift

final class LogInViewController: UIViewController {

    @IBOutlet weak var googleLogInButton: UIButton!
    @IBOutlet weak var facebookLogInButton: UIButton!
    @IBOutlet weak var appleLogInButton: UIButton!
    
    private weak var coordinator: AppCoordinator?
    private var viewModel: LogInViewModel?
    var disposeBag = DisposeBag()

    static func instantiate(viewModel: LogInViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "LogInViewStoryBoard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordinator = coordiNator
        return viewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.facebookLogInButton.isHidden = true
        setupUI()
        
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            VinylaUserManager.clearAllUserSetting()
        } catch let signOutError as NSError {
            print("Firebase Error signing out:", signOutError)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        VinylaUserManager.isFirstLogin = true
        
        if let currentUser = Auth.auth().currentUser {
            print("current user uid:",currentUser.uid)
        }
        
    }
    
    func setupUI() {
        googleLogInButton.layer.cornerRadius = 28
        facebookLogInButton.layer.cornerRadius = 28
        appleLogInButton.layer.cornerRadius = 28
    }
    @IBAction func touchUPGoogleButton(_ sender: UIButton) {
        VinylaUserManager.loginSNSCase = "Google"
        self.ShowLoadingIndicator()
        
        if let currentUser = Auth.auth().currentUser {
            self.confirmWithoutRegisterVinylaUser()
            
        }else {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                self.removeLoadingIndicator()
                return
            }
            
            let signInConfig = GIDConfiguration.init(clientID: clientID)
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard error == nil else {
                    self.removeLoadingIndicator()
                    return
                }

                guard let authentication = user?.authentication else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
                // access token 부여 받음

                VinylaUserManager.googleIdToken = authentication.idToken ?? ""
                VinylaUserManager.googleAccessToken = authentication.accessToken

                // 파베 인증정보 등록
                Auth.auth().signIn(with: credential) { result , error in
                    // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                    if let error = error {
                        print ("Error Google sign in: %@", error)
                        self.removeLoadingIndicator()
                        return
                    }else {
                        guard let userID = Auth.auth().currentUser?.uid else { return }
                        guard let userEmail = Auth.auth().currentUser?.email else { return }
                        let fcmToken = VinylaUserManager.fcmToken ?? ""
                        VinylaUserManager.firebaseUID = userID
                        
                        let logInAPITarget = APITarget.signinUser(userToken: SignInRequest(fuid: VinylaUserManager.firebaseUID ?? "", fcmToken: fcmToken))
                        
                        _ = CommonNetworkManager.request(apiType: logInAPITarget)
                            .subscribe(onSuccess: { [weak self] (model: SignInResponse) in
                                VinylaUserManager.vinylaToken = model.data?.token
                                VinylaUserManager.nickname = model.data?.nickname
                                if let eventAgree = model.data?.subscribeAgreed, eventAgree == 1 {
                                    VinylaUserManager.eventSubscribeAgreed = true
                                } else {
                                    VinylaUserManager.eventSubscribeAgreed = false
                                }
                                self?.removeLoadingIndicator()
                                self?.coordinator?.moveAndSetHomeView()
                                
                            }, onError: { [weak self] error in
                                self?.removeLoadingIndicator()
                                self?.coordinator?.moveToSignUPView()
                            })
                            .disposed(by: self.disposeBag)
                        
                    }
                }
            }
        }

    }
    
    @IBAction func touchUPAppleLogInButton(_ sender: Any) {
        VinylaUserManager.loginSNSCase = "Apple"
        
        if let currentUser = Auth.auth().currentUser {
            self.confirmWithoutRegisterVinylaUser()
        } else {
            print("self.startSignInWithAppleFlow()")
            self.startSignInWithAppleFlow()
        }
        
        
//AuthProvider 이용하여 reauth (No PoP UP)
//        let user = Auth.auth().currentUser
////        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: "email", password: "pass")
//        guard let googleIdToken = UserDefaults.standard.string(forKey: "IdToken") else { return }
//        guard let googleAccessToken = UserDefaults.standard.string(forKey: "AccessToken") else { return }
//        let credentialGoogle: AuthCredential = GoogleAuthProvider.credential(withIDToken: googleIdToken, accessToken: googleAccessToken)
//
//        user?.reauthenticate(with: credentialGoogle) { result, error  in
//          if let error = error {
//            // An error happened.
//          } else {
//            // User re-authenticated.
//            user?.delete{ error in
//                if let error = error {
//                    print(error)
//                }else {
//                    print("user 삭제완료")
//                }
//            }
//          }
//        }
        
        
//  재로그인하여 firebase reauth 탈퇴
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let signInConfig = GIDConfiguration.init(clientID: clientID)
//
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//            guard error == nil else { return }
//
//            guard let authentication = user?.authentication else { return }
//            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
//            // access token 부여 받음
//
//            guard let user = Auth.auth().currentUser else { return }
//            user.reauthenticate(with: credential) {_,_ in
//                user.delete{ error in
//                    if let error = error {
//                        print(error)
//                    }else {
//                        print("user 삭제완료")
//                    }
//                }
//            }
//
//        }

    }
    
    func confirmWithoutRegisterVinylaUser() {
        //애플로그인 fb 가입 후, 바닐라 회원가입하지 않고 홈으로 오는경우
        if let currentUser = Auth.auth().currentUser {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let fcmToken = VinylaUserManager.fcmToken ?? ""
            
            print("coordinator userID:",currentUser.uid)
            VinylaUserManager.firebaseUID = currentUser.uid
            let logInAPITarget = APITarget.signinUser(userToken: SignInRequest(fuid: userID, fcmToken: fcmToken))
            
            _ = CommonNetworkManager.request(apiType: logInAPITarget)
                .subscribe(onSuccess: { [weak self] (model: SignInResponse) in
                    print(model)
                    VinylaUserManager.vinylaToken = model.data?.token
                    VinylaUserManager.nickname = model.data?.nickname
                    self?.coordinator?.moveAndSetHomeView()
                }, onError: { [weak self] error in
                    if error as? NetworkError == NetworkError.nonExistentVinylaUser {
                        print(error)
                        self?.coordinator?.moveToSignUPView()
                    }
                })
                .disposed(by: disposeBag)
        }
        
    }
    
}

extension LogInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            /*
             Nonce 란?
             - 암호화된 임의의 난수
             - 단 한번만 사용할 수 있는 값
             - 주로 암호화 통신을 할 때 활용
             - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
             - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
             */
            guard let nonce = viewModel?.currentNonce else {
                print("Error: Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            VinylaUserManager.appleNonce = nonce
//            VinylaUserManager.appleIdToken = appleIDCredential.user
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            
            
            Auth.auth().signIn(with: credential) { authResult, error in
                
                VinylaUserManager.appleIdToken = credential.idToken
                
                // User is signed in to Firebase with Apple.
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }else {
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    guard let userEmail = Auth.auth().currentUser?.email else { return }
                    let fcmToken = VinylaUserManager.fcmToken ?? ""
                    
                    VinylaUserManager.firebaseUID = userID
                    
                    let logInAPITarget = APITarget.signinUser(userToken: SignInRequest(fuid: VinylaUserManager.firebaseUID ?? "", fcmToken: fcmToken))
                    
                    _ = CommonNetworkManager.request(apiType: logInAPITarget)
                        .subscribe(onSuccess: { [weak self] (model: SignInResponse) in
                            VinylaUserManager.vinylaToken = model.data?.token
                            VinylaUserManager.nickname = model.data?.nickname
                            if let eventAgree = model.data?.subscribeAgreed, eventAgree == 1 {
                                VinylaUserManager.eventSubscribeAgreed = true
                            } else {
                                VinylaUserManager.eventSubscribeAgreed = false
                            }
                            self?.coordinator?.moveAndSetHomeView()
                        }, onError: { [weak self] error in
                            self?.coordinator?.moveToSignUPView()
                        })
                        .disposed(by: self.disposeBag)
                    
                }
                
            }
        }
    }
}

extension LogInViewController {
    func startSignInWithAppleFlow() {
        guard let nonce = viewModel?.randomNonceString() else { return }
        viewModel?.currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = viewModel?.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
