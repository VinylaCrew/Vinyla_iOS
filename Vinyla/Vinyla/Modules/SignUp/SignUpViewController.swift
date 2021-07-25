//
//  SignUpViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit

class SignUpViewController: UIViewController {

    let storyBoardID = "SignUp"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpLogInButton(_ sender: Any) {
        guard let nextViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController else {
            return
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
