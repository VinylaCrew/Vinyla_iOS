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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
