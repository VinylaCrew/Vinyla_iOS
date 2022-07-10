//
//  MyPageViewController.swift
//  Vinyla
//
//  Created by IJ on 2022/04/28.
//

import UIKit
import MessageUI

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
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var marketingSwitch: UISwitch!
    @IBOutlet weak var loginUserLabel: UILabel!
    @IBOutlet weak var loginUserImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
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
        
        self.appVersionLabel.text =  self.viewModel?.appVersion
        
        self.viewModel?.eventSubscribeAgreed
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isAgreed in
                self.marketingSwitch.setOn(isAgreed, animated: false)
            })
            .disposed(by: disposeBag)
        
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
        
        self.contactButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sendContactMail()
            })
            .disposed(by: disposeBag)
                    
        
        self.serviceInformationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                
                let serviceInformationViewController = ServiceInformationViewController(
                    nibName: "ServiceInformationViewController",
                    bundle: Bundle(for: ServiceInformationViewController.self)
                )
                
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
        viewModel?.updateEventSubscribeAgreed()
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
    
    //MARK: - 문의하기 임시 로직 (바닐라 인스타그램 개설 후 변경)
    func sendContactMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                             이곳에 문의 내용을 작성해주세요.
                             
                             
                             -------------------
                             
                             Device Model : \(self.getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(self.getCurrentVersion())
                             
                             -------------------
                             """
            
            composeViewController.setToRecipients(["vinylacrew@gmail.com"])
            composeViewController.setSubject("<Vinyla> 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
}

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
