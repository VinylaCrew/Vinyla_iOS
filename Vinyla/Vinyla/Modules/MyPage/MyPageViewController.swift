//
//  MyPageViewController.swift
//  Vinyla
//
//  Created by IJ on 2022/04/28.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

final class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var pushTextLabel: UILabel!
    @IBOutlet weak var serviceInformationButton: UIButton!
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var marketingSwitch: UISwitch!
    @IBOutlet weak var loginUserLabel: UILabel!
    @IBOutlet weak var loginUserImageView: UIImageView!
    
    private var viewModel: MyPageViewModel?
    private weak var coordinator: AppCoordinator?
    
    var disposeBag = DisposeBag()
    
    static func instantiate(viewModel: MyPageViewModel, coordinator: AppCoordinator) -> MyPageViewController {
        let viewController = MyPageViewController(nibName: "MyPageViewController", bundle: Bundle(for: MyPageViewController.self))
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.viewModel?.loginUserText
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { loginCaseText in
                self.loginUserLabel.text = loginCaseText
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.loginUserImageName
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { loginImageName in
                self.loginUserImageView.image = UIImage(named: loginImageName)
            })
            .disposed(by: disposeBag)
        
        self.logoutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    print(firebaseAuth.currentUser?.uid)
                    self?.viewModel?.clearUserData()
                    self?.coordinator?.moveAndSetLogInView()
                    self?.coordinator?.setupToast(message: "   로그아웃 되었습니다.   ", title: nil)
                } catch let signOutError as NSError {
                    print("Error signing out:", signOutError)
                }
            })
            .disposed(by: disposeBag)
            
        
        self.withdrawButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.moveToWithdrawViewController()
            })
            .disposed(by: disposeBag)
                    
        
        self.serviceInformationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let serviceInformationViewController = ServiceInformationViewController(nibName: "ServiceInformationViewController", bundle: Bundle(for: ServiceInformationViewController.self))
                serviceInformationViewController.typeCheck = "Privacy"
                serviceInformationViewController.modalPresentationStyle = .pageSheet
                self?.present(serviceInformationViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        guard let viewModel = viewModel else { return }
        
        self.marketingSwitch.rx.value
            .skip(1)
//            .throttle(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .do(onNext: { _ in
                self.marketingSwitch.isUserInteractionEnabled = false
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                    self?.marketingSwitch.isUserInteractionEnabled = true
                })
            })
            .bind(to: viewModel.marketingSubscribed)
            .disposed(by: disposeBag)
        
        Observable.zip(viewModel.marketingCompleteSubject, viewModel.marketingSubscribed)
            .subscribe(onNext: { [weak self] apiIsSuccessed, value in
                if apiIsSuccessed {
                    let toastMessage = value ? "동의 완료" : "거절 완료"
                    self?.coordinator?.setupToast(message: "   마케팅 수신 \(toastMessage)   ", title: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNickNameLabel.text = VinylaUserManager.nickname
        viewModel?.updateUserLoginSNSCase()
    }
    
    func setupUI() {
        logoutButton.setupUnderline()
        withdrawButton.setupUnderline()
        
        pushTextLabel.numberOfLines = 0
        pushTextLabel.text = "신규 바이닐 업데이트 알림 주요 공지 등\n서비스관련 푸시 알림을 받습니다"
    }
    
    @IBAction func touchupPOPButton(_ sender: Any) {
        self.coordinator?.popViewController()
    }
}
