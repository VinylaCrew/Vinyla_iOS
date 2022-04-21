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
    @IBOutlet weak var albumSongListTableView: UITableView!
    @IBOutlet weak var deleteScrollView: UIScrollView!
    @IBOutlet weak var deleteBlurCircleView: BlurCircleView!
    //constraints
    @IBOutlet weak var albumSongListTableViewHeight: NSLayoutConstraint!

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
        setAlbumListTableViewUI()
        deleteScrollView.delegate = self
        deleteBlurCircleView.delegate = self

        print("view did load",CFGetRetainCount(self.viewModel))
    }
    deinit {
        print("deinit",CFGetRetainCount(self.viewModel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        songTitleLabel.text = viewModel?.songTitle
        viewModel?.fetchVinylInformation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("didappear",CFGetRetainCount(self.viewModel))
    }
    func setAlbumListTableViewUI() {
        albumSongListTableView.delegate = self
        albumSongListTableView.dataSource = self
        let albumSongListCellNib = UINib(nibName: "AlbumSongListTableViewCell", bundle: nil)
        albumSongListTableView.register(albumSongListCellNib, forCellReuseIdentifier: "albumSongListCell")
        albumSongListTableView.rowHeight = UITableView.automaticDimension
        albumSongListTableView.estimatedRowHeight = 24
        albumSongListTableView.separatorStyle = .none
        albumSongListTableView.backgroundColor = .black
        albumSongListTableViewHeight.constant = CGFloat(1*21) // 21size가 추가셀 생성되지 않음
        albumSongListTableView.isScrollEnabled = false
    }
}

extension DeleteInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongListCell") as? AlbumSongListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .black
        cell.albumSongTitleLabel.text = "\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
}

extension DeleteInformationViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.deleteInformationButton.alpha = 0.4
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.deleteInformationButton.alpha = 1.0
    }
}

extension DeleteInformationViewController: ButtonTapDelegate {
    func didTapPopButton() {
        coordinator?.popViewController()
    }

    func didTapFavoriteButton(sender: UIButton) {
        viewModel?.updateMainFavoriteVinylImage(isButtonSelected: sender.isSelected,imageData: Data())
    }
}
