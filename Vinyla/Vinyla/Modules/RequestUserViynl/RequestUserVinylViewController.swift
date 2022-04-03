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
        setPlaceholderTextView()
        setCountTextViewInLabel()
        albumNameTextField.delegate = self
        artistNameTextField.delegate = self
        memoTextView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUPTapGesutre(sender:)))
        imageUPLoadView.addGestureRecognizer(tapGesture)

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "작성 완료", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.vinylaMainOrangeColor()
        memoTextView.inputAccessoryView = toolBarKeyboard
    }
    @objc func touchUPTapGesutre(sender: UITapGestureRecognizer) {
        print("touch")
    }
    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touches Began")
        self.view.endEditing(true)
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

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
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    @IBAction func touchUpPopButton(_ sender: Any) {
        self.coordiNator?.dismissViewController()
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
        memoTextView.textColor = UIColor.textColor()
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

    func remitMemoTextCount() {
        memoTextView.rx.text.orEmpty
            .map{ $0.count <= 100 }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext:{ [weak self] isEditable in
                if !isEditable {
                    self?.memoTextView.text = String(self?.memoTextView.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
    }

    func setPlaceholderTextView() {
        let placeholder = "발매일자, 수록곡, 장르 등 찾으시는 바이닐의 자세한 정보를 남겨주세요."
        memoTextView.rx.didBeginEditing
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.memoTextView.text == "발매일자, 수록곡, 장르 등 찾으시는 바이닐의 자세한 정보를 남겨주세요." {
                    print("memoTextView")
                    self.memoTextView.text = nil
                    self.memoTextView.textColor = .white
                }
            })
            .disposed(by: disposeBag)
    }
}

extension RequestUserVinylViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("should begin edit")
        if self.memoTextView.text == "발매일자, 수록곡, 장르 등 찾으시는 바이닐의 자세한 정보를 남겨주세요." {
            print("memoTextView")
            self.memoTextView.text = nil
            self.memoTextView.textColor = .white
        }

        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= (memoTextView.frame.height + 75)
        }

        return true
    }
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        print("should end edit")
//        self.view.endEditing(true)
//        return true
//    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(memoTextView.text == nil || memoTextView.text == ""){
            self.memoTextView.text = "발매일자, 수록곡, 장르 등 찾으시는 바이닐의 자세한 정보를 남겨주세요."
            memoTextView.textColor = UIColor.textColor()
            self.view.endEditing(true)
            //TextViewDelegate 에서만 self.view.endEditing이 작동하지 않음
        }
    }

}
