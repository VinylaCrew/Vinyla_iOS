//
//  LevelDesignTableViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/29.
//

import UIKit

class LevelDesignTableViewCell: UITableViewCell {

    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelInformationLabel: UILabel!
    @IBOutlet weak var levelMentLabel: UILabel!
    var isGradient: Bool?
    var isOnce: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if isGradient == true && isOnce == 0{
            self.contentView.setGradient(color1: UIColor.gradientStartColor(), color2: UIColor.gradientEndColor())
            isOnce += 1
        }
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}
