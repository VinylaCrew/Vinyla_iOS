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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchVinylImageView.layer.cornerRadius = searchVinylImageView.frame.height/2
        
        customSeperatorView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
//        UIColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
