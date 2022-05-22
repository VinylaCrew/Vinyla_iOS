//
//  HomeViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var vibrancyImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var blurCircleView: BlurCircleView!
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var homeScrollContentView: UIView!
    @IBOutlet weak var recentVinylCollectionView: UICollectionView!
    @IBOutlet weak var homeMiniButtonView: UIView!
    @IBOutlet weak var vinylCountLabel: UILabel!
    @IBOutlet weak var vinylLevelGagueLabel: UILabel!
    @IBOutlet weak var collectedTextLabel: UILabel!
    @IBOutlet weak var genreTextLabel: UILabel!
    @IBOutlet weak var myGenreLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var levelGagueBackGroundView: UIView!
    @IBOutlet weak var mainLevelLabel: UILabel!
    @IBOutlet weak var levelIconImageView: UIImageView!
    @IBOutlet weak var informationLevelLabel: UILabel!
    @IBOutlet weak var homeNickNameLabel: UILabel!
    @IBOutlet weak var myPageButton: UIButton!
    

    //Constraint
    @IBOutlet weak var homeBottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomMiniViewSpace: NSLayoutConstraint!
    @IBOutlet weak var recentCollectionViewHeight: NSLayoutConstraint!
    private var levelGagueWidthConstraint: NSLayoutConstraint?
    private var homeScrollContentViewHeightConstraint: NSLayoutConstraint?

    private var disposebag = DisposeBag()
    lazy private var homeMiniButtonImageView: UIImageView = {
        let imageName = "area"
        let image = UIImage(named: imageName)
        let homeMiniButtonImageView = UIImageView(image: image!)
        homeMiniButtonImageView.frame = CGRect(x: 0, y: 0, width: 345, height: 80)
        homeMiniButtonImageView.clipsToBounds = true
        homeMiniButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        return homeMiniButtonImageView
    }()

    lazy var levelGagueView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 345, height: 3)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.5
        view.backgroundColor = UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private weak var coordinator: AppCoordinator?
    private var viewModel: HomeViewModelProtocol?
    
    static func instantiate(viewModel: HomeViewModelProtocol, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "Home") as? HomeViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel //weak이면 return 전에 viewController.viewModel 이 deinit 되며 nil상태가 되어짐
        viewController.coordinator = coordiNator
        //print("static func return 하기 전") 여기서 weak viewModel deinit
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        
        homeScrollView.contentInsetAdjustmentBehavior = .never
        setHomeButtonMiniImage()
        levelGagueBackGroundView.layer.cornerRadius = 1.5
        levelGagueBackGroundView.layer.masksToBounds = true
        levelGagueBackGroundView.addSubview(levelGagueView)
//        let leading = levelGagueView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
//        let trailing = levelGagueView.trailingAnchor.constraint(equalTo: levelGagueBackGroundView.trailingAnchor)
        // viewDidLayoutSubviews 에서 리딩 트레일링 잡으면 오류 없음
        levelGagueWidthConstraint = levelGagueView.widthAnchor.constraint(equalToConstant: 50)
        levelGagueWidthConstraint?.isActive = true
        let height = levelGagueView.heightAnchor.constraint(equalToConstant: 3)

        levelGagueView.addConstraints([height])

        recentVinylCollectionView.delegate = self
        recentVinylCollectionView.dataSource = self
        homeScrollContentView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 21/255, alpha: 1)
        recentVinylCollectionView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 21/255, alpha: 1)
        let recentCellNib = UINib(nibName: "RecentVinylCollectionViewCell", bundle: nil)
        recentVinylCollectionView.register(recentCellNib, forCellWithReuseIdentifier: "recentCell")
        blurCircleView.delegate = self
        blurCircleView.popButton.isHidden = true
        blurCircleView.setFavoriteImageButton.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapInformationLevelLabel))
        informationLevelLabel.isUserInteractionEnabled = true
        informationLevelLabel.addGestureRecognizer(tap)
        
        viewModel?.myGenre
            .subscribe(onNext: { [weak self] genre in
                self?.myGenreLabel.text = genre
            })
            .disposed(by: disposebag)
        
        self.myPageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.moveMyPageView()
            })
            .disposed(by: disposebag)
        
        setupMyPageTapGesuture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear()",VinylaUserManager.vinylaToken)
        
        updateUIHomeVinylData()
        checkMyVinyl()
        viewModel?.requestMyGenre()
        self.homeNickNameLabel.text = VinylaUserManager.nickname
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear()")
        setupRxBindFirstLoginSyncData()
        viewModel?.requestServerVinylBoxData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let homeScrollContentViewHeightConstraint = homeScrollContentViewHeightConstraint {
            homeScrollContentViewHeightConstraint.isActive = false
            self.homeScrollContentViewHeightConstraint = nil
        }

        //레이아웃 처음 계산때 647,0
        //is active false nil

        view.layoutIfNeeded()

        homeScrollContentViewHeightConstraint = homeScrollContentView.heightAnchor.constraint(equalToConstant: {
            let screenHeight = UIScreen.main.bounds.height - view.safeAreaInsets.top
            let scrollViewContentHeight = homeScrollView.contentSize.height
            if screenHeight >= scrollViewContentHeight {
                return screenHeight
            } else {
                return scrollViewContentHeight
            }
        }())
        homeScrollContentViewHeightConstraint?.isActive = true

    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        homeScrollView.contentInset = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        //viewdidload 에선 SafeareaInsets 0 view life cycle 안맞음
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        levelGagueView.leadingAnchor.constraint(equalTo: levelGagueBackGroundView.leadingAnchor).isActive = true
        //        homeScrollView.setContentOffset(CGPoint(x: 0, y: -view.safeAreaInsets.top), animated: false)

    }
    func setupRxBindFirstLoginSyncData() {
        guard let isFirstLogin = VinylaUserManager.isFirstLogin else { return }
        if isFirstLogin {
            viewModel?.isSyncVinylBox
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] isLoading in
                    print("isSyncVinylBox",isLoading)
                    if isLoading {
                        print("isLoading in VC")
                        self?.ShowLoadingIndicator()
                    }else {
                        print("done Loading in VC")
                        CoreDataManager.shared.printVinylBoxData()
                        //서버에서 다운로드된 DATA로 UI Update
                        self?.updateUIHomeVinylData()
                        self?.removeLoadingIndicator()
                    }
                })
                .disposed(by: disposebag)
            
            viewModel?.myVinylSyncData
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] vinylData in
                    self?.blurCircleView.shownCircleImageView.image = UIImage(data: vinylData)
                    self?.blurCircleView.backgroundImageView.image = UIImage(data: vinylData)
                    self?.checkMyVinyl()
                })
                .disposed(by: disposebag)
            
            viewModel?.myUserSyncData
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { [weak self] _ in
                    self?.homeNickNameLabel.text = VinylaUserManager.nickname
                })
                .disposed(by: disposebag)
        }
    }
    
    func setupMyPageTapGesuture() {
        let moveMyPageTapGesture = UITapGestureRecognizer()
        let moveMyPageTapGesture2 = UITapGestureRecognizer()

        self.homeNickNameLabel.isUserInteractionEnabled = true
        self.mainLevelLabel.isUserInteractionEnabled = true
        self.homeNickNameLabel.addGestureRecognizer(moveMyPageTapGesture)
        self.mainLevelLabel.addGestureRecognizer(moveMyPageTapGesture2)

        moveMyPageTapGesture.rx.event.bind (onNext: { [weak self] recognizer in
            self?.coordinator?.moveMyPageView()
        })
        .disposed(by: disposebag)
        
        moveMyPageTapGesture2.rx.event.bind (onNext: { [weak self] recognizer in
            self?.coordinator?.moveMyPageView()
        })
        .disposed(by: disposebag)
    }
    
    func setHomeButtonMiniImage() {
        self.homeMiniButtonView.addSubview(homeMiniButtonImageView)
        let homeBottomMiniViewHorizontal = homeMiniButtonImageView.leadingAnchor.constraint(equalTo: homeMiniButtonView.leadingAnchor)
        let homeBottomMiniViewVertical = homeMiniButtonImageView.trailingAnchor.constraint(equalTo: homeMiniButtonView.trailingAnchor)
        let homeBottomMiniViewWidthConstraint = homeMiniButtonImageView.widthAnchor.constraint(equalTo: homeMiniButtonView.widthAnchor)
        let homeBottomMiniViewHeightConstraint = homeMiniButtonImageView.heightAnchor.constraint(equalTo: homeMiniButtonView.heightAnchor)
        homeMiniButtonView.addConstraints([homeBottomMiniViewHorizontal, homeBottomMiniViewVertical, homeBottomMiniViewWidthConstraint, homeBottomMiniViewHeightConstraint])
        self.homeMiniButtonView.bringSubviewToFront(vinylCountLabel)
        self.homeMiniButtonView.bringSubviewToFront(myGenreLabel)
        self.homeMiniButtonView.bringSubviewToFront(collectedTextLabel)
        self.homeMiniButtonView.bringSubviewToFront(genreTextLabel)
        self.homeMiniButtonView.layer.cornerRadius = 8
    }

    func updateUIHomeVinylData() {
        if let viewModel = self.viewModel {
            viewModel.fetchRecentVinylData()
            viewModel.getLevelName()
                .bind(to: informationLevelLabel.rx.text, mainLevelLabel.rx.text)
                .disposed(by: disposebag)
            self.levelGagueWidthConstraint?.constant = viewModel.getLevelGagueWidth(screenSize: UIScreen.main.bounds.size.width)
            self.vinylCountLabel.text = "\(viewModel.getTotalVinylBoxCount())"
            self.vinylLevelGagueLabel.text = viewModel.getLevelGague()
            self.levelIconImageView.image = UIImage(named: viewModel.getLevelImageName())
        }
        self.recentVinylCollectionView.reloadData()
    }

    func checkMyVinyl() {
        if let myVinylImageData = self.viewModel?.myVinyl() {
            self.blurCircleView.shownCircleImageView.image = UIImage(data: myVinylImageData)
            self.blurCircleView.backgroundImageView.image = UIImage(data: myVinylImageData)
            self.blurCircleView.hideMyVinylGuideItem()
            self.blurCircleView.InstagramShareButton.isHidden = false
        } else {
            self.blurCircleView.shownCircleImageView.image = UIImage(named: "imgHomeMyvinlyDim")
            self.blurCircleView.backgroundImageView.image = UIImage(named: "imgHomeMyvinlyDim")
            self.blurCircleView.showMyVinylGuideItem()
            self.blurCircleView.InstagramShareButton.isHidden = true
        }
    }

    @IBAction func touchUpHomeButton(_ sender: UIButton) {
        coordinator?.moveToVinylBoxView()
    }
    @IBAction func tapInformationLevelLabel() {
        coordinator?.moveToLevelDesignView()
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Playball-Regular", size: 40)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imageWith(name: String?) -> UIImage? {
         let frame = CGRect(x: 0, y: -200, width: 100, height: 100)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .lightGray
         nameLabel.textColor = .white
         nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
         nameLabel.text = name
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath) as? RecentVinylCollectionViewCell else { return UICollectionViewCell() }

//        if let check = viewModel?.recentVinylBoxData, indexPath.row < check.count {
//            cell.recentVinylImageView.image = UIImage(data: check[indexPath.row].vinylImage!)
//        }else {
//            print("cell else", viewModel?.recentVinylBoxData, indexPath.row)
//            cell.recentVinylImageView.image = nil
//        }
// viewmodel로 리팩토링
        if let recentVinylImageData = viewModel?.getRecentVinylBoxData(indexPathRow: indexPath.row) {
            cell.recentVinylImageView.image = UIImage(data: recentVinylImageData)
        }else {
            cell.recentVinylImageView.image = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = floor((UIScreen.main.bounds.size.width - 66)/4)
        
        // width/4
        return CGSize(width: cellSize, height: cellSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
}

extension HomeViewController: ButtonTapDelegate {
    func didTapPopButton() {}
    
    func didTapInstagramButton() {
        
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                self.blurCircleView.InstagramShareButton.isHidden = true
                let renderer = UIGraphicsImageRenderer(size: blurCircleView.bounds.size)
                
                let renderImage = renderer.image { _ in
                    blurCircleView.drawHierarchy(in: blurCircleView.bounds, afterScreenUpdates: true)
                }
                
//                let textImage: Data = "Shawn Test".image(withAttributes: [.foregroundColor: UIColor.white,
//                                                                          .font: UIFont(name: "Playball-Regular", size: 30)],
//                                                         size: CGSize(width: 300.0, height: 150.0))!.pngData()!
                
                let textImage: Data = """
                Shawn Test
                
                
                
                
                1
                """
                    .image(withAttributes: [.foregroundColor: UIColor.white,.backgroundColor: UIColor.vinylaMainOrangeColor()
                                            , .font: UIFont(name: "Playball-Regular", size: 13)])!.pngData()!
                
                let textWithImage = textToImage(drawText: "Vinyla", inImage: renderImage, atPoint: CGPoint(x: 150, y: 340))
                
                guard let imageData = textWithImage.pngData() else { return }
                let pasteboardItems: [String: Any] = [
//                    "com.instagram.sharedSticker.stickerImage": textImage,
                    "com.instagram.sharedSticker.backgroundImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate:
                        Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options:
                                                pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:],
                                          completionHandler: nil)
                self.dismiss(animated: true) { [weak self] in
                    self?.blurCircleView.InstagramShareButton.isHidden = false
                }
            } else {
                let alert = UIAlertController(title: "알림", message: "인스타그램 설치가 필요합니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    func didTapFavoriteButton(sender: UIButton) {}
}


extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size),
                                    withAttributes: attributes)
        }
    }
}
