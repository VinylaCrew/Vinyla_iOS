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
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: LogInViewModel?
    
    static func instantiate(viewModel: LogInViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "LogInViewStoryBoard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setUI() {
        googleLogInButton.layer.cornerRadius = 28
        facebookLogInButton.layer.cornerRadius = 28
        appleLogInButton.layer.cornerRadius = 28
    }
    @IBAction func touchUpGoogleButton(_ sender: UIButton) {
        
        coordiNator?.moveToSignUPView()
    }
    
    @IBAction func justBoxTestButton(_ sender: Any) {
        guard let boxViewController = UIStoryboard(name: "VinylBoxStoryboard", bundle: nil).instantiateViewController(identifier: "VinylBox") as? VinylBoxViewController else { return }
        
        self.navigationController?.pushViewController(boxViewController, animated: true)
    }
    
}
