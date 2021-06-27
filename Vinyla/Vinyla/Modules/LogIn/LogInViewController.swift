//
//  LogInViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/06/27.
//

import UIKit

final class LogInViewController: UIViewController {

    @IBOutlet weak var googleLogInButton: UIButton!
    @IBOutlet weak var facebookLogInButton: UIButton!
    @IBOutlet weak var appleLogInButton: UIButton!
    
    let storyBoardID = "LogInViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        googleLogInButton.layer.cornerRadius = 28
        facebookLogInButton.layer.cornerRadius = 28
        appleLogInButton.layer.cornerRadius = 28
    }
}
