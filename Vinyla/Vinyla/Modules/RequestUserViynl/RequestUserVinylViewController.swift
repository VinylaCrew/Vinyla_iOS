//
//  RequestUserVinylViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/31.
//

import UIKit
import RxSwift
import RxCocoa

class RequestUserVinylViewController: UIViewController {

    @IBOutlet weak var artistMentLabel: UILabel!
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var requestUserVinylButton: UIButton!
    @IBOutlet weak var memoTextCountLabel: UILabel!
    @IBOutlet weak var imageUPLoadView: UIView!
    @IBOutlet weak var selectedUPLoadImageView: UIImageView!
    //hugging
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCountTextViewInLabel()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUPTapGesutre(sender:)))
        imageUPLoadView.addGestureRecognizer(tapGesture)
    }
    @objc func touchUPTapGesutre(sender: UITapGestureRecognizer) {
        print("touch")
    }
    @IBAction func touchUpPopButton(_ sender: Any) {
        print("pop view")
    }
    func setUI() {
        artistMentLabel.numberOfLines = 2

        selectedUPLoadImageView.layer.cornerRadius = 8

        imageUPLoadView.layer.borderWidth = 1
        imageUPLoadView.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        imageUPLoadView.layer.cornerRadius = 8
        imageUPLoadView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)

        albumNameTextField.layer.borderWidth = 1
        albumNameTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        albumNameTextField.layer.cornerRadius = 8
        albumNameTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        albumNameTextField.textColor = UIColor.white
        albumNameTextField.font = UIFont(name: "NotoSansKR-Regular", size: 15)
        albumNameTextField.addLeftPadding()

        artistNameTextField.layer.borderWidth = 1
        artistNameTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        artistNameTextField.layer.cornerRadius = 8
        artistNameTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        artistNameTextField.textColor = UIColor.white
        artistNameTextField.font = UIFont(name: "NotoSansKR-Regular", size: 15)
        artistNameTextField.addLeftPadding()

        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        memoTextView.layer.cornerRadius = 8
        memoTextView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        memoTextView.textColor = UIColor.white
        memoTextView.font = UIFont(name: "NotoSansKR-Regular", size: 13)

        requestUserVinylButton.layer.cornerRadius = 8

        if UIScreen.main.bounds.height > 812 {
            buttonTopConstraint.constant += CGFloat(UIScreen.main.bounds.height - 811)
        }
    }
    func setCountTextViewInLabel() {
        memoTextView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
//            guard let textCount = text?.count else {
//                return
//            }
                self?.memoTextCountLabel.text = String(text.count)
        })
        .disposed(by: disposeBag)
    }
}



