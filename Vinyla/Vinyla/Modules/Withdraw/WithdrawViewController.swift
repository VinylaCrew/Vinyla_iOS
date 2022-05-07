//
//  WithdrawViewController.swift
//  Vinyla
//
//  Created by Zio.H on 2022/05/07.
//

import UIKit
import RxSwift
import RxCocoa

final class WithdrawViewController: UIViewController {
    
    private var viewModel: WithdrawViewModel?
    private weak var coordinator: AppCoordinator?
    
    var disposeBag = DisposeBag()
    
    static func instantiate(viewModel: WithdrawViewModel, coordinator: AppCoordinator) -> WithdrawViewController {
        let viewController = WithdrawViewController(nibName: "WithdrawViewController", bundle: Bundle(for: WithdrawViewController.self))
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
