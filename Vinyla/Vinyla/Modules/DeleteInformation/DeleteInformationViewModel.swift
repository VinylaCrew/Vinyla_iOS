//
//  DeleteInformationViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/18.
//

import Foundation
//import RxSwift

final class DeleteInformationViewModel {
    var songTitle: String?
//    var songObservalble: Observable<String?>

    init() {
//        self.songObservalble = Observable.of("test1")
    }
    func deleteVinylBoxData() {
        print(self.songTitle)
        guard let deleteSong = songTitle else { return }
        CoreDataManager.shared.deleteSpecificVinylBox(songTitle: deleteSong)
        print("completed deleteVinylBoxData")
    }
    func updateMainFavoriteVinylImage(isButtonSelected: Bool,imageData: Data) {
        print("favorite func vm", isButtonSelected)
    }
}
