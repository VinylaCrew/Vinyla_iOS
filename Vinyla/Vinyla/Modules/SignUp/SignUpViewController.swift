//
//  SignUpViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {
    
    let storyBoardID = "SignUp"
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var instagramIDTextField: UITextField!
    @IBOutlet weak var nickNameStateLabel: UILabel!
    @IBOutlet weak var nickNameCheckButton: UIButton!
    @IBOutlet var allowEveryServiceButtons: [UIButton]!
    @IBOutlet weak var allowServiceButton: UIButton!
    @IBOutlet weak var allowPrivacyButton: UIButton!
    @IBOutlet weak var allowMarketingButton: UIButton?
    @IBOutlet weak var allowMarketingLabel: UILabel?
    @IBOutlet weak var everyAgreeButton: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!

    lazy var pointCircleView: UIView = {
    let view = UIView()
        view.frame = CGRect(x: nickNameLabel.frame.size.width, y: -2, width: 5, height: 5)
        view.backgroundColor = UIColor.vinylaMainOrangeColor()
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    //var viewModel : SignUpViewModelProtocol?
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: SignUpViewModel?

    var disposeBag = DisposeBag()
    
    static func instantiate(viewModel: SignUpViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "SignUp") as? SignUpViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextField.delegate = self
        instagramIDTextField.delegate = self
        setUI()
        setTapButtonsIsSelected()
        nickNameLabel.addSubview(pointCircleView)
        logInButton.isEnabled = false

        //viewModel = DIContainer.shared.resolve(SignUpViewModel.self)
    }
//    func setViewModel(_ viewModel: SignUpViewModelProtocol) {
//        self.viewModel = viewModel
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUpNickNameCheckButton(self.nickNameCheckButton)
         self.view.endEditing(true)
    }
    func setUI() {
        //border
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.cornerRadius = 10
        nickNameTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        instagramIDTextField.layer.borderWidth = 1
        instagramIDTextField.layer.cornerRadius = 10
        instagramIDTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "2~20자 국문, 영문, 숫자로 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)])
        nickNameTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        instagramIDTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        nickNameTextField.addLeftPadding()
        instagramIDTextField.addLeftPadding()
        
        //button
        nickNameCheckButton.layer.cornerRadius = 8
        logInButton.layer.cornerRadius = 8
        logInButton.backgroundColor = UIColor.buttonDisabledColor()
        allowMarketingLabel?.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        //allow servicebuttons
        for buttons in allowEveryServiceButtons {
            buttons.layer.cornerRadius = 8
            buttons.layer.borderWidth = 1
            buttons.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
            buttons.setBackgroundColor(UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1), for: .selected)
            buttons.clipsToBounds = true
        }
    }
    func setTapButtonsIsSelected() {
        allowServiceButton.rx.tap.subscribe(onNext: { [weak self] in
            if let serviceButton = self?.allowServiceButton {
                if serviceButton.isSelected {
                    serviceButton.isSelected = false
                }else {
                    serviceButton.isSelected = true
                    self?.presentServiceInformationView()
                }
                self?.isCheckingEveryAgreeButton()
                self?.isCheckLogInButtonLogic()
            }
        }).disposed(by: disposeBag)

        allowPrivacyButton.rx.tap.subscribe(onNext: { [weak self] in
            if let privacyButton = self?.allowPrivacyButton {
                if privacyButton.isSelected {
                    privacyButton.isSelected = false
                }else {
                    privacyButton.isSelected = true
                    let serviceInformationViewController = ServiceInformationViewController(nibName: "ServiceInformationViewController", bundle: nil)
                    serviceInformationViewController.typeCheck = "Privacy"
                    serviceInformationViewController.modalPresentationStyle = .pageSheet
                    self?.present(serviceInformationViewController, animated: true, completion: nil)
                }
                self?.isCheckingEveryAgreeButton()
                self?.isCheckLogInButtonLogic()
            }
        }).disposed(by: disposeBag)

        allowMarketingButton?.rx.tap.subscribe(onNext: { [weak self] in
            if let marketingButton = self?.allowMarketingButton {
                if marketingButton.isSelected {
                    marketingButton.isSelected = false
                }else {
                    marketingButton.isSelected = true
                }
                self?.isCheckingEveryAgreeButton()
            }
        }).disposed(by: disposeBag)
    }
    func presentServiceInformationView() {
        let serviceInformationViewController = ServiceInformationViewController(nibName: "ServiceInformationViewController", bundle: nil)
        serviceInformationViewController.typeCheck = "Service"
        serviceInformationViewController.modalPresentationStyle = .pageSheet
        self.present(serviceInformationViewController, animated: true, completion: nil)
    }
    @IBAction func touchUpPopButton(_ sender: Any) {
        coordiNator?.popViewController()
    }

    func isCheckingEveryAgreeButton() {
        if allowServiceButton.isSelected == false || allowPrivacyButton.isSelected == false || allowMarketingButton?.isSelected == false {
            self.everyAgreeButton.isSelected = false
        }
    }
    @IBAction func touchUpNickNameCheckButton(_ sender: UIButton) {
        guard let nickNameCountField = nickNameTextField.text else { return }
        var nickNameCheckValue: Int?
        if let viewModel = self.viewModel {
            nickNameCheckValue = viewModel.isValidNickName(nickNameCountField)
        }

        if nickNameCheckValue == 1 {
            nickNameCheckButton.backgroundColor = UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1)
            let attributedString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "icnLoginComplete")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: " 사용 가능한 닉네임 입니다."))
            nickNameStateLabel.attributedText = attributedString
            nickNameStateLabel.sizeToFit()

            nickNameStateLabel.textColor = UIColor.vinylaMainOrangeColor()
            isCheckLogInButtonLogic()

        } else if nickNameCheckValue == 2 || nickNameCheckValue == 3{
            var nickNameText: String = ""
            if nickNameCheckValue == 2{
                nickNameText = " 닉네임 길이가 짧습니다."
            }else if nickNameCheckValue == 3{
                nickNameText = " 올바르지 않은 형식입니다."
            }
            let attributedString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "icnLoginFail")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: nickNameText))
            nickNameStateLabel.attributedText = attributedString
            nickNameStateLabel.sizeToFit()
            nickNameStateLabel.textColor = UIColor.vinylaPurple()
            nickNameCheckButton.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 63/255, alpha: 1)
            logInButton.backgroundColor = UIColor.buttonDisabledColor()
            logInButton.isEnabled = false
            logInButton.setTitleColor(UIColor.buttonDisabledTextColor(), for: .normal)
        }
    }
    func isCheckLogInButtonLogic() {
        if allowServiceButton.isSelected && allowPrivacyButton.isSelected {
            logInButton.isEnabled = true
            logInButton.backgroundColor = UIColor.vinylaMainOrangeColor()
            logInButton.setTitleColor(.white, for: .normal)
        }else {
            logInButton.isEnabled = false
            logInButton.backgroundColor = UIColor.buttonDisabledColor()
            logInButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func touchUpLogInButton(_ sender: Any) {
        
        guard let nickNameText = nickNameTextField.text else { return }
        viewModel?.setNickNameModel(nickName: nickNameText)
        
        guard let instaGramIDText = instagramIDTextField.text else { return }
        viewModel?.setInstaGramID(instaGramID: instaGramIDText)
        
        coordiNator?.moveAndSetHomeView()
    }
    
    func isValidName(name:String)-> Bool {
        let nameRegEx = "^[a-z0-9_]+$" // this mean you can only use lower case a-z, 0-9 and underscore
        let namelTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namelTest.evaluate(with: name)
    }
    
    @IBAction func touchUpAllowEveryServiceButton(_ sender: UIButton) {
        for buttons in allowEveryServiceButtons {
            if !buttons.isSelected {
                buttons.isSelected = true
            }
        }
        self.presentServiceInformationView()
    }
    
}


extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = nickNameTextField.text else {return false}
        //키보드 delete버튼 활성화
        if string.isEmpty {
            return true
        }
        
        if text.count >= 20 {
            return false
        }
        var strings: NSString?
        
        
        let invalidCharacters =
            CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎㄲㄸㅃㅆㅉㅏㅑㅓㅕㅗㅛㅜㅠㅡㅣㅐㅒㅔㅖㅘㅙㅚㅝㅞㅟㅢ").inverted
          return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nickNameTextField.resignFirstResponder()
        touchUpNickNameCheckButton(self.nickNameCheckButton)
        self.instagramIDTextField.resignFirstResponder()
        return true
    }
}
