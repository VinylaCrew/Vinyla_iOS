//
//  AddInformationViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/06.
//

import UIKit
import RxCocoa
import RxSwift

class AddInformationViewController: UIViewController {

    lazy var saveInformationButton: UIButton = {
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
        button.setTitle("보관함에 저장하기(1/2)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        // Set the title (highlighted).
        button.setTitle("보관함에 저장하기(1/2)", for: .highlighted)
        button.setTitleColor(.black, for: .highlighted)
        
        // Tag a button.
        button.tag = 1
        
        // Add an event
//        button.addTarget(self, action: #selector(touchUpSaveBoxButton(_:)), for: .touchUpInside)
        
        return button
    }()

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var informationScrollView: UIScrollView!
    @IBOutlet weak var albumSongListTableView: UITableView!
    @IBOutlet weak var albumSongListTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var blurCircleView: BlurCircleView!

    
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: AddInformationViewModel?
    var disposebag = DisposeBag()
    
    var dataCount: Int = 1
    
    static func instantiate(viewModel: AddInformationViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "AddInformation", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "AddInformation") as? AddInformationViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setAlbumListTableViewUI()
        self.view.addSubview(saveInformationButton)
        saveInformationButton.rx.tap.subscribe(onNext:  { [weak self] in

            self?.coordiNator?.moveToAddReview(vinylDataModel: AddReviewModel.init(songTitle: self?.viewModel?.model.vinylTitleSong, vinylImageURL: self?.viewModel?.model.vinylImageURL))
        }).disposed(by: disposebag)
        
        informationScrollView.delegate = self
        blurCircleView.delegate = self
        
        songTitleLabel.text = viewModel?.model.vinylTitleSong

        guard let vinylImageURL = viewModel?.model.vinylImageURL else { return }
        blurCircleView.shownCircleImageView.setImageChache(imageURL: vinylImageURL)
        blurCircleView.backgroundImageView.setImageChache(imageURL: vinylImageURL)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        bindViynlInformationData()
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
        albumSongListTableViewHeight.constant = CGFloat(dataCount*21) // 21size가 추가셀 생성되지 않음
        albumSongListTableView.isScrollEnabled = false
    }
    func bindViynlInformationData() {
        self.viewModel?.vinylInformationData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                print("bindViynlInformationData",data)
                guard let vinylInformation = data else { return }
                if let imageURL = vinylInformation.image {
                    self?.blurCircleView.shownCircleImageView.setImageURLAndChaching(imageURL)
                    self?.blurCircleView.backgroundImageView.setImageURLAndChaching(imageURL)
                }else {
                    self?.blurCircleView.shownCircleImageView.image = UIImage()
                    self?.blurCircleView.backgroundImageView.image = UIImage()
                }
                self?.songTitleLabel.text = vinylInformation.title
            })
            .disposed(by: disposebag)
        
    }
    @IBAction func touchUpHomeFavoriteButton(_ sender: Any) {
        //home 대표 이미지 변경
        //vinly box 체크버튼 표시되고, 정렬 되는 로직
        //isFavorite = true
    }
    
}

extension AddInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongListCell") as? AlbumSongListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .black
        cell.albumSongTitleLabel.text = "\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
}

extension AddInformationViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.saveInformationButton.alpha = 0.4
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.saveInformationButton.alpha = 1.0
    }
}

extension AddInformationViewController: ButtonTapDelegate {
    func didTapFavoriteButton(sender: UIButton) {

    }

    func didTapPopButton() {
        self.coordiNator?.popViewController()
    }
}
