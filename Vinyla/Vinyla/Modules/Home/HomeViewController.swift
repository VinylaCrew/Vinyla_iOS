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

    let storyBoardID = "Home"
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: HomeViewModelProtocol?
    
    static func instantiate(viewModel: HomeViewModelProtocol, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "Home") as? HomeViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel //weak이면 return 전에 viewController.viewModel 이 deinit 되며 nil상태가 되어짐
        viewController.coordiNator = coordiNator
        //print("static func return 하기 전") 여기서 weak viewModel deinit
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        
        homeScrollView.contentInsetAdjustmentBehavior = .never
//        print("ijoom", homeScrollView.contentInset)
//        print("ijoom", homeScrollView.adjustedContentInset)
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear()")
        viewModel?.getLevelName().bind(to: informationLevelLabel.rx.text, mainLevelLabel.rx.text)
            .disposed(by: disposebag)
        if let viewModel = self.viewModel {
            levelGagueWidthConstraint?.constant = viewModel.getLevelGagueWidth(screenSize: UIScreen.main.bounds.size.width)
            vinylCountLabel.text = "\(viewModel.getTotalVinylBoxCount())"
            vinylLevelGagueLabel.text = viewModel.getLevelGague()
            levelIconImageView.image = UIImage(named: viewModel.getLevelImageName())
        }
        viewModel?.fetchRecentVinylData()
        recentCollectionViewHeight.constant = floor((UIScreen.main.bounds.size.width - 66)/4)
        recentVinylCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear()")
        setRxIndicator()
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
    func setRxIndicator() {
        if UserDefaults.standard.bool(forKey: "isFirstLogin") {
            viewModel?.isSyncVinylBox
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] isLoading in
                    print("isSyncVinylBox",isLoading)
                    if isLoading {
                        print("isLoading in VC")
                        self?.ShowLoadingIndicator()
                    }else {
                        print("done Loading in VC")
                        self?.removeLoadingIndicator()
                    }
                })
                .disposed(by: disposebag)
        }
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

    func bottomViewSetUI() {
        let deviceHeight = UIScreen.main.bounds.size.height
        print("deviceHeight")
        print(deviceHeight)
        //12 max 428 926
        //12 390 844
        if deviceHeight > 925 {
            homeBottomViewHeight.constant = CGFloat(258+61)
        } else if deviceHeight > 844 { // iPhone 11 Pro Max
            homeBottomViewHeight.constant = CGFloat(258+48) //11pro max ok
            
        } else if deviceHeight > 812 { //iPhone 12
            homeBottomViewHeight.constant = CGFloat(258+13)
        } else {
            //iPhone XS Under OK
        }
    }
    @IBAction func touchUpHomeButton(_ sender: UIButton) {
        //        coordiNator?.moveToAddInformationView()
        //        coordiNator?.moveToSearchView()
        coordiNator?.moveToVinylBoxView()
    }
    @IBAction func tapInformationLevelLabel() {
        coordiNator?.moveToLevelDesignView()
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
    func didTapPopButton() {
        
    }

    func didTapFavoriteButton(sender: UIButton) {
        print("Home VC delegate touch")
        print(sender.isSelected)
    }
}
