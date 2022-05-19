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

    lazy var deleteVinylButton: UIButton = {
        let button = UIButton()

        let width: CGFloat = self.view.bounds.width-30
        let height: CGFloat = 62

        let posX: CGFloat = 15
        let posY: CGFloat = self.view.bounds.height-28-62
        print("viewboundsheight")
        print(self.view.bounds.height)

        button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        button.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 36/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 17)
        button.titleLabel?.textAlignment = .center
        // Set the title (normal).
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(UIColor.textColor(), for: .normal)
        // Set the title (highlighted).
        button.setTitle("삭제하기", for: .highlighted)
//        button.setTitleColor(UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1), for: .highlighted)
//        button.setBackgroundColor(UIColor(red: 35/255, green: 35/255, blue: 36/255, alpha: 1), for: .highlighted)
        // Tag a button.
        button.tag = 1

        return button
    }()

    lazy var saveInformationButton: UIButton = {
        let button = UIButton()
        
        // Define the size of the button
        let width: CGFloat = self.view.bounds.width-30
        let height: CGFloat = 62
        
        // Define coordinates to be placed.
        // (center of screen)
        let posX: CGFloat = 15
        let posY: CGFloat = self.view.bounds.height-28-62
        
        // Set the button installation coordinates and size.
        button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Set the background color of the button.
        button.backgroundColor = UIColor(red: 255/255, green: 63/255, blue: 0/255, alpha: 1)
        
        // Round the button frame.
        button.layer.masksToBounds = true
        
        // Set the radius of the corner.
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 17)
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
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songReleaseDataLabel: UILabel!
    @IBOutlet weak var songGenresLabel: UILabel!
    @IBOutlet weak var songCountLabel: UILabel!
    @IBOutlet weak var songStarCountLabel: UILabel!

    @IBOutlet weak var informationScrollView: UIScrollView!
    @IBOutlet weak var albumSongListTableView: UITableView!
    @IBOutlet weak var albumSongListTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var blurCircleView: BlurCircleView!

    private weak var coordinator: AppCoordinator?
    private var viewModel: AddInformationViewModel?
    var disposebag = DisposeBag()
    
    static func instantiate(viewModel: AddInformationViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "AddInformation", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "AddInformation") as? AddInformationViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordinator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAlbumListTableViewUI()
        //DeleteMode 분기처리
        if viewModel?.isDeleteMode == true {
            self.view.addSubview(deleteVinylButton)
            deleteVinylButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.presentFavoriteVinylPOPUPView(delegate: self, mode: "delete")
                })
                .disposed(by: disposebag)

        }else {
            blurCircleView.setFavoriteImageButton.isHidden = true
            self.view.addSubview(saveInformationButton)
        }

        saveInformationButton.rx.tap.subscribe(onNext:  { [weak self] in
            guard let vinylInformationModel = self?.viewModel?.vinylInformationDataModel else { return }
//            let vinylDetailData = AddReviewModel.init(vinylImageURL: self?.viewModel?.model.vinylImageURL, songTitle: vinylInformationModel.title, songArtist: vinylInformationModel.artist, rate: vinylInformationModel.rate, rateCount: vinylInformationModel.rateCount)

            let vinylDetailData = RequestSaveVinylModel.init(id: vinylInformationModel.id,
                                                             title: vinylInformationModel.title,
                                                             artist: vinylInformationModel.artist,
                                                             image: vinylInformationModel.image,
                                                             year: vinylInformationModel.year,
                                                             genres: vinylInformationModel.genres,
                                                             tracklist: vinylInformationModel.tracklist,
                                                             rate: nil,
                                                             comment: nil)

            guard let thumbnail = self?.viewModel?.model.vinylImageURL else { return }
            self?.coordinator?.moveToAddReview(vinylDataModel: vinylDetailData,
                                               thumbnailImage: thumbnail,
                                               songRate: vinylInformationModel.rate ,
                                               songRateCount: vinylInformationModel.rateCount)
        }).disposed(by: disposebag)
        
        informationScrollView.delegate = self
        blurCircleView.delegate = self
        blurCircleView.InstagramShareButton.isHidden = true


        guard let vinylImageURL = viewModel?.model.vinylImageURL else { return }
        blurCircleView.shownCircleImageView.setImageChache(imageURL: vinylImageURL)
        blurCircleView.backgroundImageView.setImageChache(imageURL: vinylImageURL)

        bindViynlInformationData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will",viewModel!.model.vinylID,viewModel?.model.vinylTrackList.count)
        viewModel?.fetchVinylInformation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDid",viewModel?.model.vinylTrackList,viewModel?.model.vinylTitleSong)
        
        if viewModel?.model.vinylIndex == VinylaUserManager.myVInylIndex {
            self.blurCircleView.setFavoriteImageButton.isSelected = true
        }
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
        albumSongListTableViewHeight.constant = CGFloat(21) // 21size가 추가셀 생성되지 않음
        albumSongListTableView.isScrollEnabled = false
    }
    func bindViynlInformationData() {
        self.viewModel?.vinylInformationData
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] data in
                print("bindViynlInformationData",data)
                guard let vinylInformation = data else {
                    self?.songTitleLabel.text = "상세조회 데이터가 없습니다."
                    self?.saveInformationButton.isEnabled = false
                    self?.saveInformationButton.backgroundColor = UIColor.buttonDisabledColor()
                    return
                }
                //tracklist tableview
                self?.viewModel?.model.vinylTrackList = vinylInformation.tracklist
                self?.albumSongListTableViewHeight.constant = CGFloat(((self?.viewModel?.model.vinylTrackList.count)!)*24)
                //cell artist label 사이즈 고정하거나 , 긴 노래 제목 문자열 계산 필요
                self?.albumSongListTableView.reloadData()


                self?.blurCircleView.shownCircleImageView.setImageURLAndChaching(vinylInformation.image)
                self?.blurCircleView.backgroundImageView.setImageURLAndChaching(vinylInformation.image)

                self?.songTitleLabel.text = vinylInformation.title
                self?.songArtistLabel.text = vinylInformation.artist
                self?.songGenresLabel.text = vinylInformation.genres[0]
                self?.songCountLabel.text = String(vinylInformation.tracklist.count)
                self?.songReleaseDataLabel.text = String(vinylInformation.year ?? 0)
                self?.songStarCountLabel.text = String(vinylInformation.rate) + " (\(vinylInformation.rateCount)건)"

                //save button enabled setting
                self?.saveInformationButton.isEnabled = true
                self?.saveInformationButton.backgroundColor = UIColor.buttonOrangeColor()

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
        print("count",viewModel!.model.vinylTrackList.count)
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.model.vinylTrackList.count
        //return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongListCell") as? AlbumSongListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .black
        cell.albumSongTitleLabel.text = viewModel?.model.vinylTrackList[indexPath.row]
//        cell.albumSongTitleLabel.text = "\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
}

extension AddInformationViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.saveInformationButton.alpha = 0.4
        self.deleteVinylButton.alpha = 0.4
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.saveInformationButton.alpha = 1.0
        self.deleteVinylButton.alpha = 1.0
    }
}

extension AddInformationViewController: ButtonTapDelegate {
    func didTapFavoriteButton(sender: UIButton) {
        print("didTapFavoriteButton")

        if self.blurCircleView.setFavoriteImageButton.isSelected {
            //설정된 바이닐 취소
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            self.viewModel?.requestRegisterMyVinyl(dispatchGroup: dispatchGroup)
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.blurCircleView.setFavoriteImageButton.isSelected = false
                self?.coordinator?.setupToast(message: "   마이바이닐이 해제되었습니다.   ", title: nil)
            }
        } else {
            self.coordinator?.presentFavoriteVinylPOPUPView(delegate: self, mode: "vinyl")
        }
    }
    
    func didTapInstagramButton() { }

    func didTapPopButton() {
        self.coordinator?.popViewController()
    }
}

extension AddInformationViewController: POPUPButtonTapDelegate {
    func didTapDeleteButton() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.viewModel?.deleteVinylBoxData(deleteDispatchGroup: dispatchGroup)
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.coordinator?.popViewController()
            self?.coordinator?.setupToast(message: "   바이닐이 삭제되었습니다.   ", title: nil)
        }
    }
    
    //유저가 마이바이닐 등록 요청 완료했을 때
    func didTapFavoriteButton() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.viewModel?.requestRegisterMyVinyl(dispatchGroup: dispatchGroup)
        dispatchGroup.notify(queue: .main) { [weak self] in
            //MARK: ToDo 아래 코어데이터 관련 ViewModel로 변경, 변경하니깐 코어데이터 operation 에러가 나옴
            //MARK: 단일 이미지 코어데이터 저장
//            CoreDataManager.shared.clearAllObjectEntity("MyImage")
//            CoreDataManager.shared.saveImage(data: self?.blurCircleView.shownCircleImageView.image?.pngData() ?? Data())
            
            guard let myVinylImageData = self?.blurCircleView.shownCircleImageView.image?.pngData() else { return }
            self?.viewModel?.saveMyVinylCoreData(myVinylData: myVinylImageData)
            self?.blurCircleView.setFavoriteImageButton.isSelected = true
            self?.coordinator?.setupToast(message: "   마이바이닐이 등록되었습니다.   ", title: nil)
        }
    }
}
