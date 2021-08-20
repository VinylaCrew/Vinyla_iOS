//
//  SignUpViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit

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
    @IBOutlet weak var allowMarketingButton: UIButton!
    @IBOutlet weak var allowMarketingLabel: UILabel!

    //var viewModel : SignUpViewModelProtocol?
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: SignUpViewModel?
    
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
        setUI()
        
        //viewModel = DIContainer.shared.resolve(SignUpViewModel.self)
    }
//    func setViewModel(_ viewModel: SignUpViewModelProtocol) {
//        self.viewModel = viewModel
//    }
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
        logInButton.backgroundColor = UIColor.vinylaMainOrangeColor()
        allowMarketingLabel.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        //allow servicebuttons
        for buttons in allowEveryServiceButtons {
            buttons.layer.cornerRadius = 8
            buttons.layer.borderWidth = 1
            buttons.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
            buttons.setBackgroundColor(UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1), for: .selected)
            buttons.clipsToBounds = true
        }
    }
    
    @IBAction func touchUpPopButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpNickNameCheckButton(_ sender: UIButton) {
        guard let nickNameCountField = nickNameTextField.text else { return }
        var nickNameCheckValue: Int?
        if let viewModel = self.viewModel {
            nickNameCheckValue = viewModel.isValidNickName(nickNameCountField)
        }

        if nickNameCheckValue == 1 {
            nickNameCheckButton.backgroundColor = UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1)
            nickNameStateLabel.text = "사용 가능한 닉네임 입니다."
            logInButton.isEnabled = true
            logInButton.backgroundColor = UIColor.vinylaMainOrangeColor()
            logInButton.setTitleColor(.white, for: .normal)
        } else if nickNameCheckValue == 2 {
            nickNameStateLabel.text = "닉네임 길이가 짧습니다."
            nickNameCheckButton.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 63/255, alpha: 1)
            logInButton.backgroundColor = UIColor.buttonDisabledColor()
            logInButton.isEnabled = false
            logInButton.setTitleColor(UIColor.buttonDisabledTextColor(), for: .normal)
        } else if nickNameCheckValue == 3 {
            nickNameStateLabel.text = "올바르지 않은 형식입니다."
            nickNameCheckButton.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 63/255, alpha: 1)
            logInButton.backgroundColor = UIColor.buttonDisabledColor()
            logInButton.isEnabled = false
            logInButton.setTitleColor(UIColor.buttonDisabledTextColor(), for: .normal)
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
            if buttons.isSelected {
                buttons.isSelected = false
            }else {
                buttons.isSelected = true
            }
        }
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
//        if(textField .isEqual(nickNameTextField))
//        {
//            strings=string as NSString;
//            let acceptedChars = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎㄲㄸㅃㅆㅉㅏㅑㅓㅕㅗㅛㅜㅠㅡㅣㅐㅒㅔㅖㅘㅙㅚㅝㅞㅟㅢ").inverted;
//
//            if (strings!.rangeOfCharacter(from: acceptedChars.inverted).location != NSNotFound)
//            {
//                return true;
//            }
//            else
//            {
//                return false;
//            }
//        }
//        else
//        {
//            return true;
//        }
    }
}

//final class SignUpViewModel {
//    func isEmpty(_ text: String?) -> Bool {
//        guard let text = text else {return false}
//        //키보드 delete버튼 활성화
//        if string.isEmpty {
//            return true
//        }
//
//        if text.count >= 20 {
//            return false
//        }
//        var strings: NSString?
//
//
//
//        if(textField .isEqual(nickNameTextField))
//        {
//            strings=string as NSString;
//            let acceptedChars = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎㄲㄸㅃㅆㅉㅏㅑㅓㅕㅗㅛㅜㅠㅡㅣㅐㅒㅔㅖㅘㅙㅚㅝㅞㅟㅢ").inverted;
//
//            if (strings!.rangeOfCharacter(from: acceptedChars.inverted).location != NSNotFound)
//            {
//                return true;
//            }
//            else
//            {
//                return false;
//            }
//        }
//        else
//        {
//            return true;
//        }
//    }
//}
