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
    @IBOutlet weak var marketingButton: UIButton!
    var typeCheck: String?
    
    let serviceInformation: ServiceInformationModel
    let privacyInformation: PrivacyInformationModel
    let marketingInformation: MarketingModel

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.serviceInformation = ServiceInformationModel()
        self.privacyInformation = PrivacyInformationModel()
        self.marketingInformation = MarketingModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        typeCheck = "Service"
        
    }
    
    required init?(coder aCorder: NSCoder) {
        self.serviceInformation = ServiceInformationModel()
        self.privacyInformation = PrivacyInformationModel()
        self.marketingInformation = MarketingModel()
        super.init(coder: aCorder)
        print("Not Used required init")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceButton.setTitleColor(.white, for: .selected)
        serviceButton.setBackgroundColor(.black, for: .selected)
        serviceButton.setBackgroundColor(.black, for: .normal)
        
        privacyInformationButton.setTitleColor(.white, for: .selected)
        privacyInformationButton.setBackgroundColor(.black, for: .selected)
        privacyInformationButton.setBackgroundColor(.black, for: .normal)
        
        marketingButton.setTitleColor(.white, for: .selected)
        marketingButton.setBackgroundColor(.black, for: .selected)
        marketingButton.setBackgroundColor(.black, for: .normal)
        
        serviceInformationTextView.isEditable = false
        
        if typeCheck == "Service" {
            serviceButton.isSelected = true
            self.serviceInformationTextView.text = self.serviceInformation.data
        }else if typeCheck == "Privacy" {
            privacyInformationButton.isSelected = true
            self.serviceInformationTextView.text = self.privacyInformation.data
        }else {
            marketingButton.isSelected = true
            self.serviceInformationTextView.text = self.marketingInformation.data
        }

    }
    
    @IBAction func touchUPServiceInformationButton(_ sender: Any) {

        if serviceButton.isSelected == false {
            serviceButton.isSelected = true
            privacyInformationButton.isSelected = false
            marketingButton.isSelected = false
        }

        self.serviceInformationTextView.text = self.serviceInformation.data
    }
    
    @IBAction func touchUPPrivacyButton(_ sender: Any) {
        if privacyInformationButton.isSelected == false {
            privacyInformationButton.isSelected = true
            serviceButton.isSelected = false
            marketingButton.isSelected = false
        }
        
        self.serviceInformationTextView.text = self.privacyInformation.data
    }
    
    @IBAction func touchupMarketingButton(_ sender: Any) {
        if marketingButton.isSelected == false {
            marketingButton.isSelected = true
            serviceButton.isSelected = false
            privacyInformationButton.isSelected = false
        }
        
        self.serviceInformationTextView.text = self.marketingInformation.data
    }
    
    @IBAction func touchUPDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
