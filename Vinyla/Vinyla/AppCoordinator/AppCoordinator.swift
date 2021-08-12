//
//  AppCoordinator.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/31.
//

import UIKit

final class AppCoordinator {
    private var windowRootViewController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    private let window: UIWindow
    private var isLogIn: Bool?
    var songNameCD: String!
    init(window: UIWindow) {
        self.window = window
        self.isLogIn = true
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
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(searchView, animated: true)
    }
    func moveToAddInformationView() {
        let addInformationView = AddInformationViewController.instantiate(viewModel: AddInformationViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(addInformationView, animated: true)
    }
    func moveToAddReview() {
//        let a = AddReviewViewModel()
//        a.data = 매개변수
        let AddReviewView = AddReviewViewController.instantiate(viewModel: AddReviewViewModel(), coordiNator: self, songName: songNameCD)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(AddReviewView, animated: true)
    }
    func moveToVinylBoxView() {
        let vinylBoxView = VinylBoxViewController.instantiate(viewModel: VinylBoxViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(vinylBoxView, animated: true)
    }
    func popViewController() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.popViewController(animated: true)
    }
}
