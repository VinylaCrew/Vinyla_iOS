//
//  HomeViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var vibrancyImageView: UIImageView!
    let storyBoardID = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        vibrancyImageView.layer.cornerRadius = vibrancyImageView.frame.height/2
        vibrancyImageView.layer.borderWidth = 1
        vibrancyImageView.layer.borderColor = UIColor.clear.cgColor
    }
    @IBAction func touchUpHomeButton(_ sender: UIButton) {
        guard let nextViewController = UIStoryboard(name: "SearchStoryboard", bundle: nil).instantiateViewController(identifier: "Search") as? SearchViewController else {
            return
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}