//
//  SignUpViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit

class SignUpViewController: UIViewController {

    let storyBoardID = "SignUp"
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var instagramIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextField.delegate = self
        setUI()
    }
    
    func setUI() {
        //border
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.cornerRadius = 10
        nickNameTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        instagramIDTextField.layer.borderWidth = 1
        instagramIDTextField.layer.cornerRadius = 10
        instagramIDTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "6~20자 국문, 영문, 숫자로 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)])
        nickNameTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        instagramIDTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        nickNameTextField.addLeftPadding()
        instagramIDTextField.addLeftPadding()
    }
    
    @IBAction func touchUpPopButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpLogInButton(_ sender: Any) {
        guard let nextViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController else {
            return
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var strings: NSString?
        
        if(textField .isEqual(nickNameTextField))
            {
            strings=string as NSString;
            let acceptedChars = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎㄲㄸㅃㅆㅉㅏㅑㅓㅕㅗㅛㅜㅠㅡㅣㅐㅒㅔㅖㅘㅙㅚㅝㅞㅟㅢ").inverted;
            if (strings!.rangeOfCharacter(from: acceptedChars.inverted).location != NSNotFound)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
        return true;
        }
    }
}
