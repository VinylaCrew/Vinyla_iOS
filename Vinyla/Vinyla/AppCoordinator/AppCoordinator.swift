//
//  AppCoordinator.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/31.
//

import UIKit
import Firebase
import RxSwift

final class AppCoordinator {
    private var windowRootViewController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    private let window: UIWindow
    private var isLogIn: Bool?
    var songNameCD: String!
    var disposeBag = DisposeBag()

    init(window: UIWindow) {
        self.window = window
//        Coordinator에서 UID로 로그인 시도해서 성공하면 홈화면, 안되면 로그인 뷰컨으로 이동
//        self.isLogIn = true
        autoLogIn()
    }

    func autoLogIn() {
        if let currentUser = Auth.auth().currentUser {

            guard let firebaseID = Auth.auth().currentUser?.uid else { return }
            print("coordinator userID:",currentUser.uid)
//            guard let vinylaUserToken = UserDefaults.standard.string(forKey: UserDefaultsKey.vinylaToken) else { return }
            let logInAPITarget = APITarget.signinUser(userToken: SignInRequest(fuid: "nousertest", fcmToken: "12"))

            _ = CommonNetworkManager.request(apiType: logInAPITarget)
                .subscribe(onSuccess: { [weak self] (model: SignInResponse) in
                    print(model)
                    UserDefaults.standard.setValue(model.data?.token, forKey: UserDefaultsKey.vinylaToken)
                    UserDefaults.standard.setValue(model.data?.nickname, forKey: UserDefaultsKey.userNickName)
                    self?.isLogIn = true
                    self?.start()
                }, onError: { [weak self] error in
                    if error as? NetworkError == NetworkError.nonExistentVinylaUser {
                        self?.isLogIn = false
                        self?.start()
                    }
                })
                .disposed(by: disposeBag)

        }else {
            self.isLogIn = false
            self.start()
        }
    }
    
    func start() {
        guard let isLogIn = self.isLogIn else { return }

        //로그인 되지 않은 경우, LogInView로 이동
        if !isLogIn {
            let navigationController = UINavigationController(rootViewController: LogInViewController.instantiate(viewModel: LogInViewModel(), coordiNator: self))
            navigationController.navigationBar.isHidden = true
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            window.rootViewController = navigationController
        } else {
            let mainHomeViewController = HomeViewController.instantiate(viewModel: HomeViewModel(), coordiNator: self)
            let navigationController = UINavigationController(rootViewController: mainHomeViewController)
            navigationController.navigationBar.isHidden = true
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            window.rootViewController = navigationController
        }
        window.makeKeyAndVisible()
    }
    
    func moveToSignUPView() {
        let signUpView = SignUpViewController.instantiate(viewModel: SignUpViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(signUpView, animated: true)
    }
    
    func moveAndSetHomeView() {
        let homeView = HomeViewController.instantiate(viewModel: HomeViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.setViewControllers([homeView], animated: true)
    }
    
    func moveToSearchView() {
        let searchView = SearchViewController.instantiate(viewModel: SearchViewModel(), coordiNator: self)
//        let navigationSearchView = UINavigationController(rootViewController: searchView)
//        navigationSearchView.navigationBar.isHidden = true
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(searchView, animated: false)
//        navigationSearchView.modalPresentationStyle = .fullScreen
//        windowRootViewController.present(navigationSearchView, animated: true, completion: nil)
    }
    func moveToAddInformationView(vinylID: Int?, vinylImageURL: String?) {
        let addInformationViewModel = AddInformationViewModel()
        addInformationViewModel.model.vinylID = vinylID
        addInformationViewModel.model.vinylImageURL = vinylImageURL
        let addInformationView = AddInformationViewController.instantiate(viewModel: addInformationViewModel, coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(addInformationView, animated: true)
    }
    func moveToAddReview(vinylDataModel: AddReviewModel) {
        let addReviewViewModel = AddReviewViewModel()
        addReviewViewModel.model = vinylDataModel
        let AddReviewView = AddReviewViewController.instantiate(viewModel: addReviewViewModel, coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(AddReviewView, animated: true)
    }
    func moveToVinylBoxView() {
        let vinylBoxView = VinylBoxViewController.instantiate(viewModel: VinylBoxViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(vinylBoxView, animated: true)
    }
    func moveToDeleteInformationView(songTitle: String?) {
        let deleteInformationViewModel = DeleteInformationViewModel()
        print("1 Coordinator delete vm count:",CFGetRetainCount(deleteInformationViewModel))
        deleteInformationViewModel.songTitle = songTitle
        print("coordinator delete", deleteInformationViewModel.songTitle)
        let deleteInformationView = DeleteInformationViewController.instantiate(viewModel: deleteInformationViewModel, coordinator: self)
        print("2 Coordinator delete vm count:",CFGetRetainCount(deleteInformationViewModel))
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(deleteInformationView, animated: true)
        print("3 Coordinator delete vm count:",CFGetRetainCount(deleteInformationViewModel))
    }
    func moveToLevelDesignView() {
        let levelDesignView = LevelDesignViewController.instantiate(viewModel: LevelDesignViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(levelDesignView, animated: true)
    }
    func popToVinylBoxView() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        var viewStackVinylBoxView: UIViewController?
        for viewStack in windowRootViewController.viewControllers {
            if viewStack is VinylBoxViewController {
                viewStackVinylBoxView = viewStack
                break
            }
        }
        if let moveVinylBoxView = viewStackVinylBoxView {
            windowRootViewController.popToViewController(moveVinylBoxView, animated: false)
        }else {
            moveToVinylBoxView()
        }
    }
    func popViewController() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.popViewController(animated: true)
    }
    func popNoAnimationViewController() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.popViewController(animated: false)
    }
    func dismissViewController() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.dismiss(animated: true, completion: nil)
    }
    func popToHomeViewController() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.popToRootViewController(animated: true)
    }
    
}
