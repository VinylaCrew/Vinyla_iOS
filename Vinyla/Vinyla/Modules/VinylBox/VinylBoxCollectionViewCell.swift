//
//  VinylBoxCollectionViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/30.
//

import UIKit

class VinylBoxCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vinylBoxImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var signerLabel: UILabel!
    @IBOutlet weak var vinylImageViewWidth: NSLayoutConstraint!

    lazy var whiteCircleVinylView: UIView = { () -> UIView in
        let view = UIView()
        
        let width: CGFloat = 30
        let height: CGFloat = 30
        let positionX: CGFloat = 0
        let positionY: CGFloat = 0
        view.frame = CGRect(x: positionX, y: positionY, width: width, height: height)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        
        let blackCircleView = UIView()
        blackCircleView.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
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
    
    let identifier = "VinylBoxCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vinylBoxImageView.addSubview(whiteCircleVinylView)
        setAutoLayoutWhiteCircleView()

//        self.contentView.clipsToBounds = true

        self.vinylBoxImageView.frame.size.width = 50.0

//        print("vinlyboxcell", self.contentView.frame.size)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("vinlyboxcell",self.contentView.frame.size)

        setVinylBoxImageAutoLayout()
        self.vinylBoxImageView.layoutIfNeeded()
        self.vinylBoxImageView.bounds.size.width = 25.0
        vinylBoxImageView.layer.cornerRadius = vinylBoxImageView.frame.height/2


    }
    func setVinylBoxImageAutoLayout() {
//        self.vinylBoxImageView.frame.size.width =  self.contentView.frame.size.height-45
    }
    func setAutoLayoutWhiteCircleView() {
        let whiteCircleVinylViewCenterX = whiteCircleVinylView.centerXAnchor.constraint(equalTo: vinylBoxImageView.centerXAnchor)
        let whiteCircleVinylViewCenterY = whiteCircleVinylView.centerYAnchor.constraint(equalTo: vinylBoxImageView.centerYAnchor)
        let whiteCircleVinylViewWidthConstraint = whiteCircleVinylView.widthAnchor.constraint(equalToConstant: 30)
        let whiteCircleVinylViewHeightConstraint = whiteCircleVinylView.heightAnchor.constraint(equalToConstant: 30)
        contentView.addConstraints([whiteCircleVinylViewCenterX,whiteCircleVinylViewCenterY,whiteCircleVinylViewWidthConstraint,whiteCircleVinylViewHeightConstraint])
    }

}
