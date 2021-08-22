//
//  AlbumSongListTableViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/12.
//

import UIKit

class AlbumSongListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var albumSongTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
