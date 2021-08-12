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

}

extension PagingCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VinylBoxCell", for: indexPath) as? VinylBoxCollectionViewCell else { return UICollectionViewCell() }
//                cell.vinylBoxImageView.image = downScaleImage(imageData: vinylBoxes[indexPath.row].vinylImage!, for: CGSize(width: 200, height: 200), scale: 0.7)
//                cell.signerLabel.text = vinylBoxes[indexPath.row].signer
//                cell.songTitleLabel.text = vinylBoxes[indexPath.row].songTitle
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        22
    }
    
}
