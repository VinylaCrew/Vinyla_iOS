//
//  LevelDesignViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/29.
//

import UIKit

final class LevelDesignViewController: UIViewController {

    @IBOutlet weak var levelDesignTableView: UITableView!
    @IBOutlet weak var levelMentLabel: UILabel!
    @IBOutlet var levelCirclePointView: [UIView]!

    private weak var coordiNator: AppCoordinator?
    private var viewModel: LevelDesignViewModel?

    static func instantiate(viewModel: LevelDesignViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "LevelDesign", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "LevelDesign") as? LevelDesignViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        levelDesignTableView.delegate = self
        levelDesignTableView.dataSource = self
        levelDesignTableView.isScrollEnabled = false
        for pointView in levelCirclePointView {
            pointView.layer.cornerRadius = pointView.frame.size.height/2
        }
        
    }

    func setLabelTextColor() {
        guard let levelMentLabelText = levelMentLabel.text else { return  }
        let attributedString = NSMutableAttributedString(string: levelMentLabelText)

//        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: (levelMentLabelText as NSString).range(of: "Bonus"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.vinylaMainOrangeColor(), range: (levelMentLabelText as NSString).range(of: "남다르게"))

        levelMentLabel.attributedText = attributedString
    }

}

extension LevelDesignViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LevelDesignCell") as? LevelDesignTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.isGradient = true
        }
        
        return cell
    }


}
