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
    
    private weak var coordiNator: AppCoordinator?
    private weak var viewModel: HomeViewModel?
    
    static func instantiate(viewModel: HomeViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "Home") as? HomeViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        
    }
    
    func setUI() {
//        vibrancyImageView.layer.cornerRadius = vibrancyImageView.frame.height/2
//        vibrancyImageView.layer.borderWidth = 1
//        vibrancyImageView.layer.borderColor = UIColor.clear.cgColor
    }
    @IBAction func touchUpHomeButton(_ sender: UIButton) {
        coordiNator?.moveToSearchView()
    }
    
}
