//
//  AddInformationModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/17.
//

import Foundation

struct AddInformationModel {
    var vinylTitleSong: String?
    var vinylImageURL: String?
    var vinylThumbnailImage: Data?
    var vinylID: Int?
    var vinylIndex: Int?
    var uniqueIndex: Int?
    var vinylTrackList: [String?]
    
    init() {
        self.vinylTitleSong = ""
        self.vinylImageURL = ""
        self.vinylID = 0
        self.vinylTrackList = []
    }
}
