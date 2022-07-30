//
//  PaginCollectionViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/10.
//

import UIKit
import RxSwift
import RxCocoa

final class PagingCollectionViewCell: UICollectionViewCell {
    

    let cellIdentifier = "pagingCell"
    @IBOutlet weak var vinylBoxCollectionView: UICollectionView!
    var nineVinylItems = [VinylBox]() {
        didSet(oldvalue) {
            self.vinylBoxCollectionView.reloadData()
        }
    }
    weak var coordinator: AppCoordinator?
    var disposebag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vinylBoxCollectionView.delegate = self
        vinylBoxCollectionView.dataSource = self
        let vinylBoxCellNib = UINib(nibName: "VinylBoxCollectionViewCell", bundle: nil)
        vinylBoxCollectionView.register(vinylBoxCellNib, forCellWithReuseIdentifier: "VinylBoxCell")
    }
    
    func setRxVinylBoxCollectionView() {
        //아직 모델이 옵저버블이 아니기에 작동되지않음
        vinylBoxCollectionView.rx.modelSelected(VinylBox.self).subscribe(onNext: { item in
            print(item)
        }).disposed(by: disposebag)
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
    
    
}

extension PagingCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nineVinylItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VinylBoxCell", for: indexPath) as? VinylBoxCollectionViewCell else { return UICollectionViewCell() }
        if let vinylImageData = nineVinylItems[indexPath.row].vinylImage {
            cell.vinylBoxImageView.image = downScaleImage(imageData: vinylImageData, for: CGSize(width: 200, height: 200), scale: 0.7)
        }else {
            print("Load fail nineVinylItemsImage")
        }
//                cell.vinylBoxImageView.image = downScaleImage(imageData: nineVinylItems[indexPath.row].vinylImage!, for: CGSize(width: 200, height: 200), scale: 0.7)
                cell.signerLabel.text = nineVinylItems[indexPath.row].singer
                cell.songTitleLabel.text = nineVinylItems[indexPath.row].songTitle
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        22
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("self content view",self.contentView.frame.size)
        let cellHeight = (self.contentView.frame.size.height-44)/3
        let cellWidth = floor((UIScreen.main.bounds.size.width-74)/3)
        if UIScreen.main.bounds.size.height >= 812 {
            return CGSize(width: cellWidth, height: cellHeight)
        }
        return CGSize(width: 100, height: 145)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.coordinator?.moveToAddInformationView(vinylID: Int(nineVinylItems[indexPath.row].vinylID), vinylImageURL: "", isDeleteMode: true)

        /// 썸네일 이미지 추가
        self.coordinator?.moveToAddInformationViewWithIndex(
            uniqueIndex: Int(nineVinylItems[indexPath.row].uniqueIndex),
            vinylIndex: Int(nineVinylItems[indexPath.row].index),
            vinylID: Int(nineVinylItems[indexPath.row].vinylID),
            vinylImage: nineVinylItems[indexPath.row].vinylImage,
            isDeleteMode: true
        )
        
    }
}
