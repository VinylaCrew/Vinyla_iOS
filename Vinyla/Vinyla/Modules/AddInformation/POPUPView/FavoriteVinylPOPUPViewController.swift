//
//  FavoriteVinylPOPUPViewController.swift
//  Vinyla
//
//  Created by IJ . on 2022/04/17.
//

import UIKit

protocol POPUPButtonTapDelegate: AnyObject {
    func didTapFavoriteButton()
}

final class FavoriteVinylPOPUPViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    weak var delegate: POPUPButtonTapDelegate?
    
    static func initInstance(delegate: POPUPButtonTapDelegate) -> FavoriteVinylPOPUPViewController {
        let viewCotnroller = FavoriteVinylPOPUPViewController(nibName: "FavoriteVinylPOPUPViewController", bundle: Bundle(for: FavoriteVinylPOPUPViewController.self))
        viewCotnroller.delegate = delegate
        return viewCotnroller
    }
    
    deinit {
        print("deinit FavoriteVinylPOPUPViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.guideLabel.numberOfLines = 0
        self.guideLabel.text = "이 바이닐을 대표 바이닐로\n 등록하시겠어요?"
        self.popupView.layer.cornerRadius = 8
        self.popupView.layer.cornerCurve = .continuous
        
        self.registerButton.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        self.cancelButton.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 15)

    }

    @IBAction func touchUpCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func touchUpRegisterButton(_ sender: Any) {
        self.delegate?.didTapFavoriteButton()
        self.dismiss(animated: true, completion: nil)
    }
}
