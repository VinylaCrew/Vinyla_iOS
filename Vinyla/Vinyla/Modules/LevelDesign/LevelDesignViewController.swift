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
    deinit {
        print("level vc deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        levelDesignTableView.delegate = self
        levelDesignTableView.dataSource = self
        levelDesignTableView.isScrollEnabled = false
        for pointView in levelCirclePointView {
            pointView.layer.cornerRadius = pointView.frame.size.height/2
        }
        setLabelTextColor()
    }
    func setLabelTextColor() {
        guard let levelMentLabelText = levelMentLabel.text else { return  }
        let attributedString = NSMutableAttributedString(string: levelMentLabelText)

        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: (levelMentLabelText as NSString).range(of: "바이닐을"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: (levelMentLabelText as NSString).range(of: "즐기는"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: (levelMentLabelText as NSString).range(of: "방법!"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.vinylaMainOrangeColor(), range: (levelMentLabelText as NSString).range(of: "남다르게"))

        levelMentLabel.attributedText = attributedString
        levelMentLabel.font = UIFont(name: "NotoSansKR-Bold", size: 19)
    }
    @IBAction func touchUpPOPButton(_ sender: UIButton) {
        self.coordiNator?.popViewController()
    }

}

extension LevelDesignViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.levelDesignModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LevelDesignCell") as? LevelDesignTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 2 {
            cell.isGradient = true
        }
        if let levelImageName = viewModel?.levelDesignModel[indexPath.row].levelImageName {
            cell.levelImageView.image = UIImage(named: levelImageName)
        }
        cell.levelLabel.text = viewModel?.levelDesignModel[indexPath.row].level
        cell.levelInformationLabel.text = viewModel?.levelDesignModel[indexPath.row].levelName
        cell.levelMentLabel.text = viewModel?.levelDesignModel[indexPath.row].levelMent

        
        return cell
    }


}
