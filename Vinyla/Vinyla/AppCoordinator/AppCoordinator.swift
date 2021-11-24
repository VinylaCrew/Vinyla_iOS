//
//  AppCoordinator.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/31.
//

import UIKit
import Firebase

final class AppCoordinator {
    private var windowRootViewController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    private let window: UIWindow
    private var isLogIn: Bool?
    var songNameCD: String!

    init(window: UIWindow) {
        self.window = window
//        Coordinator에서 UID로 로그인 시도해서 성공하면 홈화면, 안되면 로그인 뷰컨으로 이동
        self.isLogIn = false

        if let currentUser = Auth.auth().currentUser {
            print("coordinator",currentUser)
            self.isLogIn = true
            guard let userID = Auth.auth().currentUser?.uid else { return }
            print("coordinator userID:",currentUser.uid)
        }else {
            self.isLogIn = false
        }
    }
    
    func start() {
        guard let isLogIn = self.isLogIn else { return }
        
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
    func moveToAddInformationView(vinylDataModel: String?, vinylImageURL: String?) {
        let addInformationViewModel = AddInformationViewModel()
        addInformationViewModel.model.vinylTitleSong = vinylDataModel
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
        deleteInformationViewModel.songTitle = songTitle
        print("coordinator delete", deleteInformationViewModel.songTitle)
        let deleteInformationView = DeleteInformationViewController.instantiate(viewModel: deleteInformationViewModel, coordinator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(deleteInformationView, animated: true)
    }
    func moveToLevelDesignView() {
        let levelDesignView = LevelDesignViewController.instantiate(viewModel: LevelDesignViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(levelDesignView, animated: true)
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
