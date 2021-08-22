//
//  AddReviewViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/30.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos

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

    lazy var whiteCircleVinylView: UIView = { () -> UIView in
        let view = UIView()

        let width: CGFloat = 23
        let height: CGFloat = 23
        let positionX: CGFloat = 0
        let positionY: CGFloat = 0
        view.frame = CGRect(x: positionX, y: positionY, width: width, height: height)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6

        let blackCircleView = UIView()
        blackCircleView.frame = CGRect(x: 0, y: 0, width: 3, height: 3)
        blackCircleView.backgroundColor = .black
        blackCircleView.layer.masksToBounds = true
        blackCircleView.layer.cornerRadius = blackCircleView.frame.height/2
        view.addSubview(blackCircleView)

        let blackCircleViewHorizontal = blackCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let blackCircleViewVertical = blackCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let blackCircleViewWidth = blackCircleView.widthAnchor.constraint(equalToConstant: 3)
        let blackCircleViewHeight = blackCircleView.heightAnchor.constraint(equalToConstant: 3)
        blackCircleView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([blackCircleViewHorizontal, blackCircleViewVertical, blackCircleViewWidth, blackCircleViewHeight])

        return view
    }()

    lazy var pointCircleView: UIView = {
    let view = UIView()
        view.frame = CGRect(x: recommendMentLabel.frame.size.width, y: 0, width: 5, height: 5)
        view.backgroundColor = UIColor.vinylaMainOrangeColor()
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    @IBOutlet weak var songTitleNameLabel: UILabel!
    @IBOutlet weak var reviewScrollView: UIScrollView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var starCosmosView: CosmosView!
    @IBOutlet weak var starScoreLabel: UILabel!
    @IBOutlet weak var vinylImageView: UIImageView!
    @IBOutlet weak var recommendMentLabel: UILabel!

    private weak var coordiNator: AppCoordinator?
    private var viewModel: AddReviewViewModel?
    
    static func instantiate(viewModel: AddReviewViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "AddReview", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "AddReview") as? AddReviewViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTitleNameLabel.text = viewModel?.songTitle

        self.view.addSubview(saveVinylButton)
        vinylImageView.addSubview(whiteCircleVinylView)
        recommendMentLabel.addSubview(pointCircleView)
        setAutoLayoutWhiteCircleView()
        reviewScrollView.delegate = self
        setStarUI()
    }
    func setStarUI() {
        starCosmosView.settings.emptyImage = UIImage(named: "icnOffStar")
        starCosmosView.settings.filledImage = UIImage(named: "icnStar")
        starCosmosView.backgroundColor = .black
        starCosmosView.settings.fillMode = .half
        // Change the size of the stars
        starCosmosView.settings.starSize = 40
        // Set the distance between stars
        starCosmosView.settings.starMargin = 5
        starCosmosView.rating = 0
        starCosmosView.settings.minTouchRating = 0
        starCosmosView.didFinishTouchingCosmos = { [weak self] rating in
            self?.starScoreLabel.text = "\(Int(rating*2.0))"
        }
        reviewTextView.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 8
        vinylImageView.layer.cornerRadius = vinylImageView.frame.size.height/2
    }
    func setAutoLayoutWhiteCircleView() {
        let whiteCircleVinylViewCenterX = whiteCircleVinylView.centerXAnchor.constraint(equalTo: vinylImageView.centerXAnchor)
        let whiteCircleVinylViewCenterY = whiteCircleVinylView.centerYAnchor.constraint(equalTo: vinylImageView.centerYAnchor)
        let whiteCircleVinylViewWidthConstraint = whiteCircleVinylView.widthAnchor.constraint(equalToConstant: 23)
        let whiteCircleVinylViewHeightConstraint = whiteCircleVinylView.heightAnchor.constraint(equalToConstant: 23)
        vinylImageView.addConstraints([whiteCircleVinylViewCenterX,whiteCircleVinylViewCenterY,whiteCircleVinylViewWidthConstraint,whiteCircleVinylViewHeightConstraint])
    }
    @IBAction func touchUpBackButton(_ sender: Any) {
        coordiNator?.popViewController()
        
    }
    
    @IBAction func touchUpSaveBoxButton(_ sender: Any) {
        CoreDataManager.shared.saveVinylBox(songTitle: (viewModel?.songTitle)!, singer: "IU", vinylImage: (UIImage(named: "testdog")?.jpegData(compressionQuality: 0.01))!)
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
