//
//  PaginCollectionViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/10.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell {
    

    let cellIdentifier = "pagingCell"
    @IBOutlet weak var vinylBoxCollectionView: UICollectionView!
    var nineVinylItems = [VinylBox]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vinylBoxCollectionView.delegate = self
        vinylBoxCollectionView.dataSource = self
        let vinylBoxCellNib = UINib(nibName: "VinylBoxCollectionViewCell", bundle: nil)
        vinylBoxCollectionView.register(vinylBoxCellNib, forCellWithReuseIdentifier: "VinylBoxCell")
        
        print("Paging")
        print(UIScreen.main.bounds.size.height)
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
                cell.vinylBoxImageView.image = downScaleImage(imageData: nineVinylItems[indexPath.row].vinylImage!, for: CGSize(width: 200, height: 200), scale: 0.7)
                cell.signerLabel.text = nineVinylItems[indexPath.row].signer
                cell.songTitleLabel.text = nineVinylItems[indexPath.row].songTitle
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        22
    }
    
}
