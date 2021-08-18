//
//  DeleteInformationViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/15.
//

import UIKit
import RxSwift
import RxCocoa

class DeleteInformationViewController: UIViewController {

    lazy var deleteInformationButton: UIButton = {
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
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)

        // Set the title (highlighted).
        button.setTitle("삭제하기", for: .highlighted)
        button.setTitleColor(UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1), for: .highlighted)
        button.setBackgroundColor(UIColor(red: 35/255, green: 35/255, blue: 36/255, alpha: 1), for: .highlighted)

        // Tag a button.
        button.tag = 1

        // Add an event
//        button.addTarget(self, action: #selector(touchUpSaveBoxButton(_:)), for: .touchUpInside)
        return button
    }()

    @IBOutlet weak var songTitleLabel: UILabel!
    private weak var coordinator: AppCoordinator?
    private var viewModel: DeleteInformationViewModel?
    var disposebag = DisposeBag()
    static func instantiate(viewModel: DeleteInformationViewModel, coordinator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "DeleteInformation", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "DeleteInformation") as? DeleteInformationViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(deleteInformationButton)
        deleteInformationButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel?.deleteVinylBoxData()
            self?.coordinator?.popViewController()
        }).disposed(by: disposebag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        songTitleLabel.text = viewModel?.songTitle
        
    }
}
