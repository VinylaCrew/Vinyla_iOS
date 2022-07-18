//
//  RequestUserVinylViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/31.
//

import UIKit
import Photos

import RxSwift
import RxCocoa

class RequestUserVinylViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var artistMentLabel: UILabel!
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var requestUserVinylButton: UIButton!
    @IBOutlet weak var memoTextCountLabel: UILabel!
    @IBOutlet weak var imageUPLoadView: UIView!
    @IBOutlet weak var selectedUPLoadImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumImageLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var selectedImageCloseButton: UIButton!
    @IBOutlet weak var imageCountLabel: UILabel!
    //hugging
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    var fCurTextfieldBottom: CGFloat?
    
    lazy var albumImageCircleView: UIView = {
    let view = UIView()
        view.frame = CGRect(x: albumImageLabel.frame.size.width, y: 0, width: 5, height: 5)
        view.backgroundColor = UIColor.vinylaMainOrangeColor()
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    lazy var pointCircleView: UIView = {
    let view = UIView()
        view.frame = CGRect(x: albumNameLabel.frame.size.width, y: 0, width: 5, height: 5)
        view.backgroundColor = UIColor.vinylaMainOrangeColor()
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    lazy var artistPointCircleView: UIView = {
    let view = UIView()
        view.frame = CGRect(x: artistNameLabel.frame.size.width, y: 0, width: 5, height: 5)
        view.backgroundColor = UIColor.vinylaMainOrangeColor()
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    let imagePicker = UIImagePickerController()
    private weak var coordinator: AppCoordinator?
    private var viewModel: RequestUserVinylViewModel?
    var disposeBag = DisposeBag()

    static func instantiate(viewModel: RequestUserVinylViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "RequestUserVinyl", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "RequestUserVinyl") as? RequestUserVinylViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordinator = coordiNator
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPlaceholderTextView()
        setCountTextViewInLabel()
        limitCommentTextCount()
        
        albumNameTextField.delegate = self
        artistNameTextField.delegate = self
        memoTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUPTapGesutre(sender:)))
        imageUPLoadView.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "작성 완료", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.vinylaMainOrangeColor()
        memoTextView.inputAccessoryView = toolBarKeyboard
        
        //imagepicker
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        self.selectedImageCloseButton.isHidden = true
        self.selectedUPLoadImageView.isHidden = true
        
        self.requestUserVinylButton.rx.tap
            .do(onNext: { [weak self] in self?.ShowLoadingIndicator() })
            .bind(onNext: { [weak self] in
                self?.viewModel?.requestUploadUserVinyl()
            })
            .disposed(by: disposeBag)
        
        self.selectedImageCloseButton.rx.tap
            .observeOn(MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] in
                self?.selectedImageCloseButton.isHidden = true
                self?.selectedUPLoadImageView.isHidden = true
                self?.selectedUPLoadImageView.image = nil
                self?.imageCountLabel.text = "0"
            })
            .disposed(by: disposeBag)
        
        
        guard let viewModel = viewModel else { return }
        albumNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.userAlbumName)
            .disposed(by: disposeBag)
            
        artistNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.userArtistName)
            .disposed(by: disposeBag)
        
        memoTextView.rx.text
            .orEmpty
            .bind(to: viewModel.userMemo)
            .disposed(by: disposeBag)
        
        viewModel.isUpload
            .subscribe(onNext: { [weak self] isUpload in
                self?.removeLoadingIndicator()
                
                if isUpload {
                    self?.coordinator?.dismissViewControllerWithAlertMessage()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.apiError
            .subscribe(onNext: { [weak self] error in
                self?.removeLoadingIndicator()
                
                print("ViewModel error", error)
                if error == .requestDataError {
                    self?.coordinator?.setupToastPresentViewController(message: "   앨범 이름과 이미지, 아티스트명 을 입력해 주세요.   ", title: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestPhotoAuthorization()
    }
    
    func requestPhotoAuthorization() {
        
        if #available(iOS 13, *) {
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    print("Album: 권한 허용")
                case .denied:
                    print("Album: 권한 거부")
                case .restricted, .notDetermined:
                    print("Album: 선택하지 않음")
                default:
                    break
                }
            })
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
                switch authorizationStatus {
                case .authorized:
                    print("Album: 권한 허용")
                    break
                case .denied:
                    print("Album: 권한 거부")
                    break
                case .limited:
                    break
                case .notDetermined:
                    break
                case .restricted:
                    print("user restricted")
                @unknown default:
                    print("unknown requestAuthorization")
                }
            }
        }
        
    }
    
    @objc func touchUPTapGesutre(sender: UITapGestureRecognizer) {
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touches Began")
        self.view.endEditing(true)
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            //text view 만 키보드 올라가게
            if self.fCurTextfieldBottom == nil {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    @objc
    func keyboardWillDisappear(notification: NSNotification) {
        print("keyboardwillDisappear")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @IBAction func touchUpPopButton(_ sender: Any) {
        self.coordinator?.dismissViewController()
    }
    
    func setUI() {
        self.albumNameLabel.addSubview(pointCircleView)
        self.artistNameLabel.addSubview(artistPointCircleView)
        self.albumImageLabel.addSubview(albumImageCircleView)
        
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
    
    func limitCommentTextCount() {
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

extension RequestUserVinylViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var userImage: UIImage? = nil
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage = originalImage
        }
        
        self.selectedUPLoadImageView.image = userImage
        
        self.viewModel?.userImage = userImage?.pngData()
        
        self.selectedImageCloseButton.isHidden = false
        self.selectedUPLoadImageView.isHidden = false
        self.imageCountLabel.text = "1"
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
