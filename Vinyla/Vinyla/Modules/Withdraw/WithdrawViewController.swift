//
//  WithdrawViewController.swift
//  Vinyla
//
//  Created by Zio.H on 2022/05/07.
//

import UIKit

import Firebase
import GoogleSignIn
import AuthenticationServices
import RxSwift
import RxCocoa

final class WithdrawViewController: UIViewController {
    
    private var viewModel: WithdrawViewModel?
    private weak var coordinator: AppCoordinator?
    
    
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var circlePointView: [UIView]!
    @IBOutlet weak var wiithdrawLabel1: UILabel!
    @IBOutlet weak var wiithdrawLabel2: UILabel!
    @IBOutlet weak var withdrawButton: UIButton!
    
    @IBOutlet weak var popButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    static func instantiate(viewModel: WithdrawViewModel, coordinator: AppCoordinator) -> WithdrawViewController {
        let viewController = WithdrawViewController(nibName: "WithdrawViewController", bundle: Bundle(for: WithdrawViewController.self))
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.withdrawButton.isEnabled = false
        bindRxItems()
        setupUI()
    }
    
    func bindRxItems() {
        self.popButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
        
        self.checkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.checkButton.isSelected {
                    self.checkButton.isSelected = false
                    self.withdrawButton.isEnabled = false
                } else {
                    self.checkButton.isSelected = true
                    self.withdrawButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        self.withdrawButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.withdrawVinylaUser()
                self.withdrawButton.isEnabled = false
                
            })
            .disposed(by: disposeBag)
        
        viewModel?.isDoneWithdraw
            .subscribe(onNext: { [weak self] isDone in
                if isDone {
                    self?.viewModel?.clearUserData()
                    self?.coordinator?.moveAndSetLogInView()
                    self?.coordinator?.setupToast(message: "   회원 탈퇴 되었습니다.   ", title: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        for item in circlePointView {
            item.layer.cornerRadius = item.frame.size.height/2
        }
        
        self.wiithdrawLabel1.numberOfLines = 0
        self.wiithdrawLabel2.numberOfLines = 0
        self.wiithdrawLabel1.font = UIFont(name: "NotoSansKR-Regular", size: 13)
        self.wiithdrawLabel2.font = UIFont(name: "NotoSansKR-Regular", size: 13)
        self.wiithdrawLabel1.text = "바닐라에 수집된 바이닐 정보 및 계정이용 정보는 모두 삭제되며 복구 할 수 없습니다."
        
        self.checkButton.layer.cornerRadius = 8
        self.checkButton.layer.borderWidth = 1
        self.checkButton.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        self.checkButton.setBackgroundColor(UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1), for: .selected)
        self.checkButton.clipsToBounds = true
        
        self.withdrawButton.layer.masksToBounds = true
        self.withdrawButton.layer.cornerRadius = 8.0
        self.withdrawButton.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 17)
        self.withdrawButton.titleLabel?.textAlignment = .center
        self.withdrawButton.setTitle("탈퇴하기", for: .disabled)
        self.withdrawButton.setBackgroundColor(UIColor.withdrawBackgroundColor(), for: .disabled)
        self.withdrawButton.setTitleColor(UIColor.textColor(), for: .disabled)
        self.withdrawButton.setTitle("탈퇴하기", for: .normal)
        self.withdrawButton.setTitleColor(.white, for: .normal)
        self.withdrawButton.setBackgroundColor(UIColor.vinylaMainOrangeColor(), for: .normal)
        
        let attributedString = NSMutableAttributedString(string: readLabel.text ?? "")
        attributedString.addAttribute(.foregroundColor, value: UIColor.vinylaMainOrangeColor(), range: ((readLabel.text ?? "") as NSString).range(of: "주의사항"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: ((readLabel.text ?? "") as NSString).range(of: "을 꼭 읽어주세요."))
        
        self.readLabel.attributedText = attributedString
        self.readLabel.font = UIFont(name: "NotoSansKR-Bold", size: 19)
    }
    
    func withdrawVinylaUser() {
        self.showLoadingIndicator()
        
        if VinylaUserManager.loginSNSCase == "Google" {
            
            self.withdrawGoogleUser()
            
        } else {
            
            self.startSignInWithAppleFlow()
        }
    }
    
    func withdrawGoogleUser() {
        /// 재로그인하여 firebase reauth 탈퇴
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
            guard error == nil else {
                self?.viewModel?.isDoneWithdraw.onNext(false)
                self?.removeLoadingIndicator()
                return
            }
            
            guard let authentication = user?.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
            
            guard let user = Auth.auth().currentUser else { return }
            
            if user.uid != VinylaUserManager.firebaseUID {
                self?.coordinator?.setupToast(message: "   바이닐에 로그인 했던 계정으로 로그인 해주세요.   ", title: nil)
                self?.removeLoadingIndicator()
                return
            } else {
                
                user.reauthenticate(with: credential) { [weak self] _,_ in
                    user.delete{ error in
                        if let error = error {
                            print(error)
                            self?.viewModel?.isDoneWithdraw.onNext(false)
                            self?.removeLoadingIndicator()
                        }else {
                            print("user 삭제완료")
                            self?.viewModel?.isDoneWithdraw.onNext(true)
                            self?.removeLoadingIndicator()
                        }
                    }
                }
                
            }
            
        }
    }
    
    
    
}

extension WithdrawViewController: ASAuthorizationControllerDelegate {
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
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }else {
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    guard let user = Auth.auth().currentUser else { return }
                    
                    if userID != VinylaUserManager.firebaseUID {
                        self?.coordinator?.setupToast(message: "   바이닐에 로그인 했던 계정으로 로그인 해주세요.   ", title: nil)
                        self?.removeLoadingIndicator()
                        return
                    } else {
                        user.reauthenticate(with: credential) { [weak self] _,_ in
                            user.delete{ error in
                                if let error = error {
                                    print(error)
                                    self?.viewModel?.isDoneWithdraw.onNext(false)
                                    self?.removeLoadingIndicator()
                                }else {
                                    print("user 삭제완료")
                                    self?.viewModel?.isDoneWithdraw.onNext(true)
                                    self?.removeLoadingIndicator()
                                }
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.removeLoadingIndicator()
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
        
    }
}


extension WithdrawViewController {
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


extension WithdrawViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

