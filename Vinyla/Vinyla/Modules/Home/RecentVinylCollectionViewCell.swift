//
//  RecentVinylCollectionViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/11.
//

import UIKit

class RecentVinylCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recentVinylImageView: UIImageView!
    let identifier = "recentCell"
    lazy var whiteCircleVinylView: UIView = { () -> UIView in
        let view = UIView()
        
        let width: CGFloat = 23
        let height: CGFloat = 23
        let positionX: CGFloat = 0
        let positionY: CGFloat = 0
        view.frame = CGRect(x: positionX, y: positionY, width: width, height: height)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        
        let blackCircleView = UIView()
        blackCircleView.frame = CGRect(x: 0, y: 0, width: 3, height: 3)
        blackCircleView.backgroundColor = .black
        blackCircleView.layer.masksToBounds = true
        blackCircleView.layer.cornerRadius = blackCircleView.frame.height/2
        view.addSubview(blackCircleView)
        
        let blackCircleViewHorizontal = blackCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let blackCircleViewVertical = blackCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let blackCircleViewWidth = blackCircleView.widthAnchor.constraint(equalToConstant: 3)
        let blackCircleViewHeight = blackCircleView.heightAnchor.constraint(equalToConstant: 3)
        blackCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([blackCircleViewHorizontal, blackCircleViewVertical, blackCircleViewWidth, blackCircleViewHeight])
        
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.backgroundColor = .black
        self.contentView.addSubview(whiteCircleVinylView)
        setAutoLayoutWhiteCircleView()
        
        // contentview  imageview whiteview
        self.contentView.clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.contentView.frame.height/2
//        self.recentVinylImageView.layer.cornerRadius = self.recentVinylImageView.frame.height/2
        print("content height", self.contentView.frame.height/2)
        print("image height", self.recentVinylImageView.frame.height/2)
    }
    func setAutoLayoutWhiteCircleView() {
        let whiteCircleVinylViewCenterX = whiteCircleVinylView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let whiteCircleVinylViewCenterY = whiteCircleVinylView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let whiteCircleVinylViewWidthConstraint = whiteCircleVinylView.widthAnchor.constraint(equalToConstant: 23)
        let whiteCircleVinylViewHeightConstraint = whiteCircleVinylView.heightAnchor.constraint(equalToConstant: 23)
        contentView.addConstraints([whiteCircleVinylViewCenterX,whiteCircleVinylViewCenterY,whiteCircleVinylViewWidthConstraint,whiteCircleVinylViewHeightConstraint])
    }

}
