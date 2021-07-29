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
    @IBOutlet weak var vinylBoxCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        vinylBoxCollectionView.dataSource = self
        vinylBoxCollectionView.delegate = self
        let vinylBoxCellNib = UINib(nibName: "VinylBoxCollectionViewCell", bundle: nil)
        vinylBoxCollectionView.register(vinylBoxCellNib, forCellWithReuseIdentifier: "VinylBoxCell")
        vinylCountLabel.text = "0개"
    }
    
    func setUI() {
        addVinylButton.layer.cornerRadius = 24
        nextBoxButton.layer.borderWidth = 1
        nextBoxButton.layer.borderColor = CGColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        nextBoxButton.layer.cornerRadius = 24
    }
    //cell 크기 100,170

}

extension VinylBoxViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VinylBoxCell", for: indexPath) as? VinylBoxCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
}
