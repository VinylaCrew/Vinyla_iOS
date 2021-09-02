//
//  RequestUserVinylViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/31.
//

import UIKit
import RxSwift
import RxCocoa

class RequestUserVinylViewController: UIViewController, UITextFieldDelegate{

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
    var fCurTextfieldBottom: CGFloat?

    private weak var coordiNator: AppCoordinator?
    private var viewModel: RequestUserVinylViewModel?
    var disposeBag = DisposeBag()

    static func instantiate(viewModel: RequestUserVinylViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "RequestUserVinyl", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "RequestUserVinyl") as? RequestUserVinylViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCountTextViewInLabel()
        albumNameTextField.delegate = self
        artistNameTextField.delegate = self
        memoTextView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUPTapGesutre(sender:)))
        imageUPLoadView.addGestureRecognizer(tapGesture)

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func touchUPTapGesutre(sender: UITapGestureRecognizer) {
        print("touch")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
//            print(self.fCurTextfieldBottom)
//            guard let bottom = self.fCurTextfieldBottom else { return }
//            if bottom <= self.view.frame.height - keyboardHeight {
//                print(self.fCurTextfieldBottom)
//                return
//            }
            //text view 만 키보드 올라가게
            if self.fCurTextfieldBottom == nil {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    @objc func keyboardWillDisappear(notification: NSNotification) {
        print("keyboardwillDisappear")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
//        if self.view.bounds.origin.y != 0 {
//            self.view.bounds.origin.y = 0
//        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fCurTextfieldBottom = textField.frame.origin.y + textField.frame.height
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
                self?.memoTextCountLabel.text = String(text.count)
        })
        .disposed(by: disposeBag)
    }
}

extension RequestUserVinylViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("should begin edit")
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= memoTextView.frame.height
        }
//        self.view.frame.origin.y -= memoTextView.frame.height
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("should end edit")
        self.view.endEditing(true)
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("did end edit")
        self.view.endEditing(true)
    }
}


