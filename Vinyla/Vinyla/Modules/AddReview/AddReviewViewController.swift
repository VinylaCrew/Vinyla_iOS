//
//  AddReviewViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/30.
//

import UIKit
import RxSwift
import RxCocoa

class AddReviewViewController: UIViewController {
    
    //화면위 고정되는 저장 버튼
    lazy var saveVinylButton: UIButton = {
        let button = UIButton()
        
        // Define the size of the button
        let width: CGFloat = self.view.bounds.width-30
        let height: CGFloat = 62
        
        // Define coordinates to be placed.
        // (center of screen)
        let posX: CGFloat = 15
        let posY: CGFloat = self.view.bounds.height-28-62
        print("viewboundsheight")
        print(self.view.bounds.height)
        
        // Set the button installation coordinates and size.
        button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Set the background color of the button.
        button.backgroundColor = UIColor(red: 255/255, green: 63/255, blue: 0/255, alpha: 1)
        
        // Round the button frame.
        button.layer.masksToBounds = true
        
        // Set the radius of the corner.
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
        // Set the title (normal).
        button.setTitle("보관함에 저장하기(2/2)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        // Set the title (highlighted).
        button.setTitle("보관함에 저장하기(2/2)", for: .highlighted)
        button.setTitleColor(.black, for: .highlighted)
        
        // Tag a button.
        button.tag = 1
        
        // Add an event
        button.addTarget(self, action: #selector(touchUpSaveBoxButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @IBOutlet weak var songTitleNameLabel: UILabel!
    @IBOutlet weak var reviewScrollView: UIScrollView!
    var songName: String?
    private weak var coordiNator: AppCoordinator?
    private weak var viewModel: AddReviewViewModel?
    
    static func instantiate(viewModel: AddReviewViewModel, coordiNator: AppCoordinator, songName: String?) -> UIViewController {
        let storyBoard = UIStoryboard(name: "AddReview", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "AddReview") as? AddReviewViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        viewController.songName = songName
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTitleNameLabel.text = songName
        self.view.addSubview(saveVinylButton)
        reviewScrollView.delegate = self
    }
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        coordiNator?.popViewController()
        
    }
    
    @IBAction func touchUpSaveBoxButton(_ sender: Any) {
        coordiNator?.songNameCD = nil
        coordiNator?.moveToVinylBoxView()
    }
}

extension AddReviewViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.saveVinylButton.alpha = 0.4
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.saveVinylButton.alpha = 1.0
    }
}
