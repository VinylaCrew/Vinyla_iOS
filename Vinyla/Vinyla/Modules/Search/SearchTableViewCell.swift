//
//  SearchTableViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/29.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchVinylImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var customSeperatorView: UIView!

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
        view.alpha = 0.5

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
        searchVinylImageView.layer.cornerRadius = searchVinylImageView.frame.height/2
        searchVinylImageView.addSubview(whiteCircleVinylView)
        setAutoLayoutWhiteCircleView()
        customSeperatorView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
//        UIColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        self.searchVinylImageView.setImageURLAndChaching("Cancel")
//        self.searchVinylImageView.image = nil
    }

    func setAutoLayoutWhiteCircleView() {
        let whiteCircleVinylViewCenterX = whiteCircleVinylView.centerXAnchor.constraint(equalTo: searchVinylImageView.centerXAnchor)
        let whiteCircleVinylViewCenterY = whiteCircleVinylView.centerYAnchor.constraint(equalTo: searchVinylImageView.centerYAnchor)
        let whiteCircleVinylViewWidthConstraint = whiteCircleVinylView.widthAnchor.constraint(equalToConstant: 23)
        let whiteCircleVinylViewHeightConstraint = whiteCircleVinylView.heightAnchor.constraint(equalToConstant: 23)
        searchVinylImageView.addConstraints([whiteCircleVinylViewCenterX,whiteCircleVinylViewCenterY,whiteCircleVinylViewWidthConstraint,whiteCircleVinylViewHeightConstraint])
    }
    
}
