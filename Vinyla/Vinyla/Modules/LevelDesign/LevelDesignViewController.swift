//
//  LevelDesignViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/29.
//

import UIKit

final class LevelDesignViewController: UIViewController {

    @IBOutlet weak var levelDesignTableView: UITableView!

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
        return cell
    }


}
