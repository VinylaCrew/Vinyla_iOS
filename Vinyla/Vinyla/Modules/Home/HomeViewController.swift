//
//  HomeViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/11.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var vibrancyImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var blurCircleView: BlurCircleView!
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var homeScrollContentView: UIView!
    @IBOutlet weak var recentVinylCollectionView: UICollectionView!
    
    //Constraint
    @IBOutlet weak var homeBottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomMiniViewSpace: NSLayoutConstraint!
    @IBOutlet weak var bottomTopSpace: NSLayoutConstraint!
    
    let storyBoardID = "Home"
    
    private weak var coordiNator: AppCoordinator?
    private weak var viewModel: HomeViewModel?
    
    static func instantiate(viewModel: HomeViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "Home") as? HomeViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(UIScreen.main.bounds.size.height)
//        self.homeScrollView.frame.size.height = UIScreen.main.bounds.size.height

        homeScrollView.contentInsetAdjustmentBehavior = .never
//        if let imageData = testImageView.image?.jpegData(compressionQuality: 1) {
//            CoreDataManager.shared.saveImage(data: imageData)
//        }
        
//        CoreDataManager.shared.delete(imageID: "name1")
        recentVinylCollectionView.delegate = self
        recentVinylCollectionView.dataSource = self
        homeScrollContentView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 21/255, alpha: 1)
        recentVinylCollectionView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 21/255, alpha: 1)
        
        let recentCellNib = UINib(nibName: "RecentVinylCollectionViewCell", bundle: nil)
        recentVinylCollectionView.register(recentCellNib, forCellWithReuseIdentifier: "recentCell")
//        iphone 12
//        bottomTopSpace.constant += 18

        //        bottomViewSetUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let testCoreImage = CoreDataManager.shared.fetchImage()
//        self.homeImageView.image = UIImage(data: testCoreImage[0].favoriteImage!)
        bottomViewSetUI()
        CoreDataManager.shared.printData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        print(self.blurCircleView.layer.frame.height-375)
        if UIScreen.main.bounds.size.height > 812 {
            //1번만 작동되도록 홈뷰 돌아올때마다 constant 추가가됨
//            bottomMiniViewSpace.constant +=  (self.blurCircleView.layer.frame.height-375)
            self.homeScrollView.isScrollEnabled = false
        }
        print(homeScrollView.frame.size.height)
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
//        coordiNator?.moveToSearchView()
        coordiNator?.moveToVinylBoxView()
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath) as? RecentVinylCollectionViewCell else { return UICollectionViewCell() }
        cell.recentVinylImageView.image = nil
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //iphone 12 81,81
        
        return CGSize(width: 77, height: 77)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
}
