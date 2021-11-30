//
//  LogInViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/06/27.
//

import UIKit
import Firebase
import GoogleSignIn

final class LogInViewController: UIViewController {

    @IBOutlet weak var googleLogInButton: UIButton!
    @IBOutlet weak var facebookLogInButton: UIButton!
    @IBOutlet weak var appleLogInButton: UIButton!
    
    let storyBoardID = "LogInViewController"
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: LogInViewModel?

    static func instantiate(viewModel: LogInViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "LogInViewStoryBoard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let currentUser = Auth.auth().currentUser {
            print("current user uid:",currentUser.uid)
        }
    }
    
    func setUI() {
        googleLogInButton.layer.cornerRadius = 28
        facebookLogInButton.layer.cornerRadius = 28
        appleLogInButton.layer.cornerRadius = 28
    }
    @IBAction func touchUPGoogleButton(_ sender: UIButton) {
        self.coordiNator?.moveToSignUPView()
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
//            UserDefaults.standard.setValue(authentication.idToken!, forKey: "IdToken")
//            UserDefaults.standard.setValue(authentication.accessToken, forKey: "AccessToken")
//
//            // 파베 인증정보 등록
//            Auth.auth().signIn(with: credential) { result , error in
//                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
//                if let error = error {
//                    print(error)
//                }else {
//                    guard let userID = Auth.auth().currentUser?.uid else { return }
//                    guard let userEmail = Auth.auth().currentUser?.email else {
//                        return
//                    }
//                    print("User UID",type(of: userID),userEmail)
//                    UserDefaults.standard.setValue(userID, forKey: "UID")
//                    self.coordiNator?.moveToSignUPView()
//                }
//            }
//        }
    }
    
    @IBAction func touchUPAppleLogInButton(_ sender: Any) {
//AuthProvider 이용하여 reauth (No PoP UP)
        let user = Auth.auth().currentUser
//        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: "email", password: "pass")
        guard let googleIdToken = UserDefaults.standard.string(forKey: "IdToken") else { return }
        guard let googleAccessToken = UserDefaults.standard.string(forKey: "AccessToken") else { return }
        let credentialGoogle: AuthCredential = GoogleAuthProvider.credential(withIDToken: googleIdToken, accessToken: googleAccessToken)

        user?.reauthenticate(with: credentialGoogle) { result, error  in
          if let error = error {
            // An error happened.
          } else {
            // User re-authenticated.
            user?.delete{ error in
                if let error = error {
                    print(error)
                }else {
                    print("user 삭제완료")
                }
            }
          }
        }
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
    
}
