//
//  FavoriteVinylPOPUPViewController.swift
//  Vinyla
//
//  Created by IJ . on 2022/04/17.
//

import UIKit

protocol POPUPButtonTapDelegate: AnyObject {
    func didTapFavoriteButton()
    func didTapDeleteButton()
}

final class FavoriteVinylPOPUPViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    weak var delegate: POPUPButtonTapDelegate?
    var mode: String?
    
    static func initInstance(delegate: POPUPButtonTapDelegate, mode: String) -> FavoriteVinylPOPUPViewController {
        let viewController = FavoriteVinylPOPUPViewController(nibName: "FavoriteVinylPOPUPViewController", bundle: Bundle(for: FavoriteVinylPOPUPViewController.self))
        viewController.delegate = delegate
        viewController.mode = mode
        print("init")
        return viewController
    }
    
    deinit {
        print("deinit FavoriteVinylPOPUPViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("popupview viewDidLoad")
        self.guideLabel.numberOfLines = 0
        
        self.popupView.layer.cornerRadius = 8
        self.popupView.layer.cornerCurve = .continuous
        
        self.registerButton.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        self.cancelButton.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        
        if self.mode == "vinyl" {
            self.guideLabel.text = "이 바이닐을 대표 바이닐로\n 등록하시겠어요?"
            self.registerButton.setTitle("등록", for: .normal)
            self.registerButton.setTitleColor(UIColor.vinylaMainOrangeColor(), for: .normal)
        }else if self.mode == "delete" {
            self.guideLabel.text = "이 바이닐을 정말 삭제하시겠어요?"
            self.registerButton.setTitle("삭제", for: .normal)
            self.registerButton.setTitleColor(UIColor.deleteOKPopupColor(), for: .normal)
        }

    }

    @IBAction func touchUpCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func touchUpRegisterButton(_ sender: Any) {
        if self.mode == "vinyl" {
            self.delegate?.didTapFavoriteButton()
        }else if self.mode == "delete" {
            self.delegate?.didTapDeleteButton()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
