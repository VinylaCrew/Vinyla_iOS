//
//  VinylBoxViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/26.
//

import UIKit

class VinylBoxViewController: UIViewController {
    
    let storyBoardID = "VinylBox"
    @IBOutlet weak var vinylCountLabel: UILabel!
    @IBOutlet weak var addVinylButton: UIButton!
    @IBOutlet weak var nextBoxButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var vinylBoxPagingCollectionView: UICollectionView!
    
    private weak var coordiNator: AppCoordinator?
    private weak var viewModel: VinylBoxViewModel?
    
    private var vinylBoxes = [VinylBox]()
    
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
        let vinylBoxCellNib = UINib(nibName: "PaginCollectionViewCell", bundle: nil)
        vinylBoxPagingCollectionView.register(vinylBoxCellNib, forCellWithReuseIdentifier: "pagingCell")
        vinylCountLabel.text = "0개"
        
        
        
//        for i in 1...20 {
//            CoreDataManager.shared.saveVinylBox(songTitle: "level\(i)", singer: "espa", vinylImage: (UIImage(named: "testdog")?.jpegData(compressionQuality: 0))!)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vinylBoxes = CoreDataManager.shared.fetchVinylBox()
        CoreDataManager.shared.printVinylBoxData()
       
        vinylBoxPagingCollectionView.reloadData()
        
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
        coordiNator?.popViewController()
    }
    
}

extension VinylBoxViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 9 //vinylBoxes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VinylBoxCell", for: indexPath) as? VinylBoxCollectionViewCell else { return UICollectionViewCell() }
//        cell.vinylBoxImageView.image = downScaleImage(imageData: vinylBoxes[indexPath.row].vinylImage!, for: CGSize(width: 200, height: 200), scale: 0.7)
//        cell.signerLabel.text = vinylBoxes[indexPath.row].signer
//        cell.songTitleLabel.text = vinylBoxes[indexPath.row].songTitle
//        return cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagingCell", for: indexPath) as? PaginCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.size.width
        let cellHeight = vinylBoxPagingCollectionView.frame.size.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    
    
    
    
}

//extension VinylBoxViewController: UIScrollViewDelegate {
//        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
//        {
//            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
//            let layout = self.vinylBoxPagingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
//            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
//            var offset = targetContentOffset.pointee
//            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
//            var roundedIndex = round(index)
//
//            // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
//            // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
//            // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
//            if scrollView.contentOffset.x > targetContentOffset.pointee.x {
//                roundedIndex = floor(index)
//            } else {
//                roundedIndex = ceil(index)
//            }
//
//            // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
//            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//            targetContentOffset.pointee = offset
//        }
//}
