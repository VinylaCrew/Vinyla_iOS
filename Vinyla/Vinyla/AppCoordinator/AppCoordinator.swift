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
    private let toastStyle: ToastStyle = {
        var toastStyle = ToastStyle()
        toastStyle.messageFont = UIFont(name: "NotoSansKR-Regular", size: 14)!
        toastStyle.backgroundColor = .white
        toastStyle.messageColor = .black
        toastStyle.cornerRadius = 20
        return toastStyle
    }()
    private var disposeBag = DisposeBag()

    init(window: UIWindow) {
        self.window = window
        self.window.overrideUserInterfaceStyle = .light

        autoLogIn()
    }

    private func autoLogIn() {
        if let currentUser = Auth.auth().currentUser, VinylaUserManager.isFirstLogin == false {
            
            guard let firebaseID = Auth.auth().currentUser?.uid else { return }
            guard let fcmToken = VinylaUserManager.fcmToken else { print("fcmToken guard let error",VinylaUserManager.fcmToken)
                return }
            print("coordinator userID:",currentUser.uid)
            //            guard let vinylaUserToken = UserDefaults.standard.string(forKey: UserDefaultsKey.vinylaToken) else { return }
            let logInAPITarget = APITarget.signinUser(userToken: SignInRequest(fuid: VinylaUserManager.firebaseUID ?? "", fcmToken: fcmToken))
            
            _ = CommonNetworkManager.request(apiType: logInAPITarget)
                .subscribe(onSuccess: { [weak self] (model: SignInResponse) in
                    print(model)
                    VinylaUserManager.vinylaToken = model.data?.token
                    VinylaUserManager.nickname = model.data?.nickname
                    if let eventAgree = model.data?.subscribeAgreed, eventAgree == 1 {
                        VinylaUserManager.eventSubscribeAgreed = true
                    } else {
                        VinylaUserManager.eventSubscribeAgreed = false
                    }
                    
                    self?.isLogIn = true
                    self?.start()
                }, onError: { [weak self] error in
                    self?.confirmLoginProcessError(error: error)
                    
                })
                .disposed(by: disposeBag)
            
        }else {
            self.isLogIn = false
            self.start()
        }
    }
    
    //MARK: setting window rootvc logic
    private func start() {
        guard let isLogIn = self.isLogIn else { return }
        //MARK: isFirstLogin test code임, 추후 제거
//        VinylaUserManager.isFirstLogin = true
        
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
    
    func confirmLoginProcessError(error: Error) {
        
        self.setupInternetConnectAlertView()
        
//        let isInternetConnectedError = "\(error)".contains("-1009")
//
//        if isInternetConnectedError {
//            self.setupInternetConnectAlertView()
//        }else {
//            self.isLogIn = false
//            self.start()
//        }
    }
    
    func setupInternetConnectAlertView() {
        let alert = UIAlertController(title: "로그인 실패", message: "인터넷 연결을 확인해주세요.", preferredStyle: .alert)

        let defaultAction =  UIAlertAction(title: "재시도", style: UIAlertAction.Style.default) { [weak self] _ in
            self?.autoLogIn()
        }
        
        let cancelAction = UIAlertAction(title: "로그인화면 이동", style: UIAlertAction.Style.default) { [weak self] _ in
            self?.isLogIn = false
            VinylaUserManager.myVInylIndex = -1
            CoreDataManager.shared.clearAllObjectEntity("MyImage")
            CoreDataManager.shared.clearAllObjectEntity("VinylBox")
            self?.start()
        }

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.window.rootViewController = UIViewController()
        self.window.makeKeyAndVisible()
        
        self.window.rootViewController?.present(alert, animated: false)
    }
    
    //MARK: Move ViewControllers
    func moveAndSetLogInView() {
        let loginView = LogInViewController.instantiate(viewModel: LogInViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.setViewControllers([loginView], animated: true)
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
        windowRootViewController.pushViewController(searchView, animated: false)
    }

    func moveMyPageView() {
        let myPageViewController = MyPageViewController.instantiate(viewModel: MyPageViewModel(), coordinator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(myPageViewController, animated: true)
    }

    func moveToAddInformationView(vinylID: Int?, vinylTthumbURL: String?, isDeleteMode: Bool) {
        let addInformationViewModel = AddInformationViewModel()
        addInformationViewModel.model.vinylID = vinylID
        addInformationViewModel.model.vinylImageURL = vinylTthumbURL
        addInformationViewModel.isDeleteMode = isDeleteMode
        let addInformationView = AddInformationViewController.instantiate(viewModel: addInformationViewModel, coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(addInformationView, animated: true)
    }

    func moveToAddInformationViewWithIndex(vinylIndex: Int,vinylID: Int?, vinylImage: Data?, isDeleteMode: Bool) {
        let addInformationViewModel = AddInformationViewModel()
        addInformationViewModel.model.vinylID = vinylID
        addInformationViewModel.model.vinylIndex = vinylIndex
        addInformationViewModel.model.vinylThumbnailImage = vinylImage
        addInformationViewModel.isDeleteMode = isDeleteMode
        let addInformationView = AddInformationViewController.instantiate(viewModel: addInformationViewModel, coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(addInformationView, animated: true)
    }


    func moveToAddReview(vinylDataModel: RequestSaveVinylModel, thumbnailImage: String, songRate: Double?, songRateCount: Int?) {
        let addReviewViewModel = AddReviewViewModel()
        addReviewViewModel.model = vinylDataModel
        addReviewViewModel.thumbnailImage = thumbnailImage
        addReviewViewModel.songRate = songRate
        addReviewViewModel.songRateCount = songRateCount
        let AddReviewView = AddReviewViewController.instantiate(viewModel: addReviewViewModel, coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(AddReviewView, animated: true)
    }
    
    func moveToVinylBoxView() {
        let vinylBoxView = VinylBoxViewController.instantiate(viewModel: VinylBoxViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(vinylBoxView, animated: true)
    }
    
    func moveToDeleteInformationView(vinylID: Int64, songTitle: String?) {
        let deleteInformationViewModel = DeleteInformationViewModel()
        deleteInformationViewModel.vinylID = vinylID
        deleteInformationViewModel.songTitle = songTitle
        let deleteInformationView = DeleteInformationViewController.instantiate(viewModel: deleteInformationViewModel, coordinator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(deleteInformationView, animated: true)
    }
    
    func moveToLevelDesignView() {
        let levelDesignView = LevelDesignViewController.instantiate(viewModel: LevelDesignViewModel(), coordiNator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(levelDesignView, animated: true)
    }
    
    func moveToWithdrawViewController() {
        let withdrawView = WithdrawViewController.instantiate(viewModel: WithdrawViewModel(), coordinator: self)
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.pushViewController(withdrawView, animated: true)
    }
    
    func presentFavoriteVinylPOPUPView(delegate: POPUPButtonTapDelegate, mode: String) {
        let favoriteViewController = FavoriteVinylPOPUPViewController.initInstance(delegate: delegate, mode: mode)
        favoriteViewController.modalPresentationStyle = .overFullScreen
        windowRootViewController?.present(favoriteViewController, animated: true, completion: nil)
    }
    
    func presentRequestUserVinylView() {
        let requestUserViynlView = RequestUserVinylViewController.instantiate(viewModel: RequestUserVinylViewModel(), coordiNator: self)
        requestUserViynlView.modalPresentationStyle = .fullScreen
        windowRootViewController?.present(requestUserViynlView, animated: true, completion: nil)
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
    
    func dismissViewControllerWithAlertMessage() {
        guard let windowRootViewController = self.windowRootViewController else { return }
        windowRootViewController.dismiss(animated: true) {
            let alert = UIAlertController(title: nil, message: "찾는 바이닐 요청이 정상적으로 요청되었습니다.", preferredStyle: .alert)
            alert.view.tintColor = UIColor.vinylaMainOrangeColor()
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            windowRootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupToast(message: String, title: String?) {
        guard let windowRootViewController = self.windowRootViewController else { return }
        
        windowRootViewController.view.makeToast(message, duration: 1.5, position: .littleupBottom, title: title, style: self.toastStyle)
        
//        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 400.0))
//        customView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
//        customView.backgroundColor = .blue
//        windowRootViewController.view.showToast(customView, duration: 2.0, position: .center)
    }
    
    func setupToastPresentViewController(message: String, title: String?) {
        print(self.windowRootViewController?.presentationController,self.windowRootViewController?.presentationController,self.windowRootViewController?.presentedViewController)
        
        guard let presentedViewController = self.windowRootViewController?.presentedViewController else { return }
        
        presentedViewController.view.makeToast(message, duration: 1.5, position: .littleupBottom, title: title, style: self.toastStyle)
    }
    
}
