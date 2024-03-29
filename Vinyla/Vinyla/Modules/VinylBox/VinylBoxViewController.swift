//
//  VinylBoxViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/26.
//

import UIKit
import RxSwift
import RxCocoa

final class VinylBoxViewController: UIViewController {
    
    let storyBoardID = "VinylBox"
    @IBOutlet weak var vinylCountLabel: UILabel!
    @IBOutlet weak var addVinylButton: UIButton!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var nextBoxButton: UIButton!
    @IBOutlet weak var popVinylBoxViewButton: UIButton!
    @IBOutlet weak var vinylBoxPagingCollectionView: UICollectionView!
    
    lazy private var emptyGuideView: UIView = {
       let view = EmptyGuideView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 510))
        return view
    }()
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: VinylBoxViewModel?

    //VinylBox Model
    private var vinylBoxes = [VinylBox]()
    var totalPageNumber: Int?

    let disposebag = DisposeBag()
    static func instantiate(viewModel: VinylBoxViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "VinylBox", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "VinylBox") as? VinylBoxViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        vinylBoxPagingCollectionView.dataSource = self
        vinylBoxPagingCollectionView.delegate = self
        let vinylBoxCellNib = UINib(nibName: "PagingCollectionViewCell", bundle: nil)
        vinylBoxPagingCollectionView.register(vinylBoxCellNib, forCellWithReuseIdentifier: "pagingCell")

        self.addVinylButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.coordiNator?.moveToSearchView()
        }).disposed(by: disposebag)

        self.nextBoxButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.scrollToNextCell()
        }).disposed(by: disposebag)
        
        self.vinylBoxPagingCollectionView.addSubview(emptyGuideView)
        emptyGuideView.translatesAutoresizingMaskIntoConstraints = false
        emptyGuideView.leftAnchor.constraint(equalTo: vinylBoxPagingCollectionView.leftAnchor, constant: round((self.view.bounds.width-375)/2) ).isActive = true
        emptyGuideView.isHidden = true
        

        viewModel?.isDeletedVinylData
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isTrue in
                if isTrue {
                        print("updateUIBox")
                        if let viewModel = self?.viewModel {
                            self?.vinylCountLabel.text = "\(viewModel.getTotalVinylBoxCount())개"
                        }
                        self?.viewModel?.updateVinylBoxesAndReversBoxes()
                        self?.vinylBoxPagingCollectionView.reloadData()
                    print("isTrue",isTrue)
                    if Thread.isMainThread {
                        print("isTrue MainThread")
                    }else {
                        print("isTrue backThread")
                    }
                }else {
                    print("isTrue",isTrue)
                    if Thread.isMainThread {
                        print("isTruefalse: MainThread")
                    }else {
                        print("isTruefalse: backThread")
                    }
                }
            })
            .disposed(by: disposebag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel = self.viewModel else { return }
        
        //ViewModel 로직으로 변경작업중 함수 코드
        print("box viewWillAppear")
        viewModel.updateVinylBoxesAndReversBoxes()
        vinylBoxPagingCollectionView.reloadData()
        
        
        DispatchQueue.main.async { [weak self] in
            self?.vinylCountLabel.text = "\(self?.viewModel?.getTotalVinylBoxCount() ?? 0)개"
            self?.configureNextButtonPage()
            self?.userNickNameLabel.text = VinylaUserManager.nickname
        }

        print("getCountVinylBoxData: ",viewModel.getTotalVinylBoxCount())
        
        viewModel.getLevelName()
            .bind(to: self.levelNameLabel.rx.text)
            .disposed(by: disposebag)
        
        self.levelImageView.image = UIImage(named: viewModel.getLevelImageName())

        if viewModel.getTotalVinylBoxCount() == 0 {
            //MARK: emptyGuideVIew
            DispatchQueue.main.async { [weak self] in
                self?.emptyGuideView.isHidden = false
            }
        }else {
            DispatchQueue.main.async { [weak self] in
                self?.emptyGuideView.isHidden = true
            }
        }

    }
    
    
    func downScaleImage(imageData: Data, for size: CGSize, scale:CGFloat) -> UIImage {
        // dataBuffer가 즉각적으로 decoding되는 것을 막아줍니다.
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else { return UIImage() }
        let maxDimensionInPixels = max(size.width, size.height) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true, //  thumbNail을 만들 때 decoding이 일어나도록 합니다.
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        // 위 옵션을 바탕으로 다운샘플링 된 `thumbnail`을 만듭니다.
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return UIImage() }
        return UIImage(cgImage: downsampledImage)
    }
    
    func setUI() {
        addVinylButton.layer.cornerRadius = 24
        nextBoxButton.layer.borderWidth = 1
        nextBoxButton.layer.borderColor = CGColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        nextBoxButton.layer.cornerRadius = 24
    }
    //cell 크기 100,170
    @IBAction func touchUpPreviousButton(_ sender: UIButton) {
        coordiNator?.popToHomeViewController()
    }

    func configureNextButtonPage() {
        viewModel?.updatePageNumber()
        let pageInfromationString: String = viewModel?.pageString ?? "" //"다음 서랍 \(self.viewModel?.nowPageNumber)/\(self.viewModel?.totalPageNumber ?? 1)"
        let attributedString = NSMutableAttributedString(string: pageInfromationString)
        let font = UIFont(name: "NotoSansKR-Regular", size: 15)
        attributedString.addAttribute(.font, value: font, range: (pageInfromationString as NSString).range(of: pageInfromationString))
        attributedString.addAttribute(.foregroundColor, value: UIColor.vinylaTextGray(), range: (pageInfromationString as NSString).range(of: "/\(self.viewModel?.totalPageNumber ?? 1)"))
        self.nextBoxButton.setAttributedTitle(attributedString, for: .normal)
    }

    func scrollToNextCell(){

        //get cell size
        let cellSize = view.frame.size

        //get current content Offset of the Collection view
        let contentOffset = vinylBoxPagingCollectionView.contentOffset

        if vinylBoxPagingCollectionView.contentSize.width <= vinylBoxPagingCollectionView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            vinylBoxPagingCollectionView.scrollRectToVisible(r, animated: true)
            self.viewModel?.nowPageNumber = 1

        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            vinylBoxPagingCollectionView.scrollRectToVisible(r, animated: true);
            self.viewModel?.nowPageNumber = Int((vinylBoxPagingCollectionView.contentOffset.x + cellSize.width) / cellSize.width) + 1
        }

        self.configureNextButtonPage()

//                //get cell size
//        let cellSize = CGSize(width: vinylBoxPagingCollectionView.frame.width, height: vinylBoxPagingCollectionView.frame.height)
//
//                //get current content Offset of the Collection view
//                let contentOffset = vinylBoxPagingCollectionView.contentOffset;
//
//                //scroll to next cell
//
//        vinylBoxPagingCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
}

extension VinylBoxViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let pageNumber = viewModel?.totalPageNumber else { return 0 }
        return pageNumber //page
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VinylBoxCell", for: indexPath) as? VinylBoxCollectionViewCell else { return UICollectionViewCell() }
        //        cell.vinylBoxImageView.image = downScaleImage(imageData: vinylBoxes[indexPath.row].vinylImage!, for: CGSize(width: 200, height: 200), scale: 0.7)
        //        cell.signerLabel.text = vinylBoxes[indexPath.row].signer
        //        cell.songTitleLabel.text = vinylBoxes[indexPath.row].songTitle
        //        return cell

        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagingCell", for: indexPath) as? PagingCollectionViewCell else { return UICollectionViewCell() }
        
//        let odds = reverseVinylBoxes.enumerated().filter {
//            [weak self] (index: Int, element: VinylBox) -> Bool in
//            guard let pageNumber = totalPageNumber else { return false }
//            if indexPath.row != pageNumber-1 {
//                return (indexPath.row*9 <= index && index <= ((indexPath.row+1)*9-1))
//            }else {
//                return (indexPath.row*9 <= index && index <= vinylBoxes.count-1)
//            }
//        }.map { (index: Int, element: VinylBox) -> VinylBox in
//            return element
//        }
        guard let pagingVinylItems = viewModel?.getPagingVinylBoxItems(indexPath: indexPath) else {
            print("PagingVinlyBoxItemsError")
            return UICollectionViewCell()
        }
//        print("test odds 정렬된 9개씩 데이터", testOdds)
        //셀 내부 컬렉션뷰가 셀 재사용으로 인해 indexpath.item 안맞는 문제발생
//        cell.nineVinylItems = odds
        cell.nineVinylItems = pagingVinylItems
        cell.coordinator = self.coordiNator
//        cell.vinylBoxCollectionView.reloadData() =>didSet으로 리팩토링
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.size.width
        let cellHeight = vinylBoxPagingCollectionView.frame.size.height
        //        print("VinylBoxSize",cellWidth,cellHeight)
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.vinylBoxPagingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        viewModel?.nowPageNumber = Int(round(index))+1
        DispatchQueue.main.async { [weak self] in
        self?.configureNextButtonPage()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
