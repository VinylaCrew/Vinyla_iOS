//
//  WithdrawViewController.swift
//  Vinyla
//
//  Created by Zio.H on 2022/05/07.
//

import UIKit
import RxSwift
import RxCocoa

final class WithdrawViewController: UIViewController {
    
    private var viewModel: WithdrawViewModel?
    private weak var coordinator: AppCoordinator?
    
    
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var circlePointView: [UIView]!
    @IBOutlet weak var wiithdrawLabel1: UILabel!
    @IBOutlet weak var wiithdrawLabel2: UILabel!
    
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
    }
    
    func setupUI() {
        for item in circlePointView {
            item.layer.cornerRadius = item.frame.size.height
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

}
