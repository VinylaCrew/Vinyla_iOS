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

    @IBOutlet weak var guideLabel: UILabel!
    weak var delegate: POPUPButtonTapDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("override init")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.guideLabel.numberOfLines = 0
        self.guideLabel.text = "이 바이닐을 대표 바이닐로\n 등록하시겠어요?"

    }

    @IBAction func touchUpCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func touchUpRegisterButton(_ sender: Any) {
        self.delegate?.didTapFavoriteButton()
        self.dismiss(animated: true, completion: nil)
    }
}
