//
//  ServiceInformationViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/11/23.
//

import UIKit

final class ServiceInformationViewController: UIViewController {

    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var privacyInformationButton: UIButton!
    @IBOutlet weak var serviceInformationTextView: UITextView!
    var typeCheck: String?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("override init")
    }
    required init?(coder aCorder: NSCoder) {
        super.init(coder: aCorder)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceButton.setTitleColor(.white, for: .selected)
        serviceButton.setBackgroundColor(.black, for: .selected)
        serviceButton.setBackgroundColor(.black, for: .normal)
        privacyInformationButton.setTitleColor(.white, for: .selected)
        privacyInformationButton.setBackgroundColor(.black, for: .selected)
        privacyInformationButton.setBackgroundColor(.black, for: .normal)
        serviceInformationTextView.isEditable = false

        if typeCheck == "Service" {
            serviceButton.isSelected = true
            self.serviceInformationTextView.text = "Service 약관"
        }else {
            privacyInformationButton.isSelected = true
            self.serviceInformationTextView.text = "Privacy 약관"
        }

    }
    @IBAction func touchUPServiceInformationButton(_ sender: Any) {

        if serviceButton.isSelected == false {
            serviceButton.isSelected = true
            privacyInformationButton.isSelected = false
        }

        self.serviceInformationTextView.text = "제 1 조 (목적) \n 본 약관은 Vinyla (이하 '바닐라 크루')이 운영하는 '서비스'를 이용함에 있어 '바닐라 크루'와 회원간의 이용 조건 및 제반 절차, 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 한다. \n 제 2 조 (용어의 정의)이 약관에서 사용하는 용어의 정의는 아래와 같다. \n①'사이트'라 함은 바닐라 크루가 서비스를 에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 설정한 가상의 영업장 또는 바닐라 크루가 운영하는 앱서비스를 제공하는 모든 매체를 통칭한다. \n ②라 함은 바닐라 크루가 운영하는 사이트를 통해 개인 소장 및 평가 등의 목적으로 등록하는 자료를 DB화하여 각각의 목적에 맞게 분류 가공, 집계하여 정보를 제공하는 서비스와 사이트에서 제공하는 모든 부대 서비스를 말한다."
    }
    @IBAction func touchUPPrivacyButton(_ sender: Any) {
        if privacyInformationButton.isSelected == false {
            privacyInformationButton.isSelected = true
            serviceButton.isSelected = false
        }
    }

    @IBAction func touchUPDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
