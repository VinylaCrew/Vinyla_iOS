//
//  MyPageViewController.swift
//  Vinyla
//
//  Created by IJ on 2022/04/28.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    
    private var viewModel: MyPageViewModel?
    private weak var coordinator: AppCoordinator?
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var pushTextLabel: UILabel!
    @IBOutlet weak var serviceInformationButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    static func instantiate(viewModel: MyPageViewModel, coordinator: AppCoordinator) -> MyPageViewController {
        let viewController = MyPageViewController(nibName: "MyPageViewController", bundle: Bundle(for: MyPageViewController.self))
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushTextLabel.numberOfLines = 0
        pushTextLabel.text = "신규 바이닐 업데이트 알림 주요 공지 등\n서비스관련 푸시 알림을 받습니다"
        self.serviceInformationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let serviceInformationViewController = ServiceInformationViewController(nibName: "ServiceInformationViewController", bundle: Bundle(for: ServiceInformationViewController.self))
                serviceInformationViewController.typeCheck = "Privacy"
                serviceInformationViewController.modalPresentationStyle = .pageSheet
                self?.present(serviceInformationViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNickNameLabel.text = VinylaUserManager.nickname
    }
    @IBAction func touchupPOPButton(_ sender: Any) {
        self.coordinator?.popViewController()
    }
}
