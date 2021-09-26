//
//  VinylBoxViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation

final class VinylBoxViewModel {

    var vinylBoxes = [VinylBox]()
    var reverseVinylBoxes = [VinylBox]()

    var totalPageNumber: Int?

    func updateVinylBoxesAndReversBoxes() {
        vinylBoxes = CoreDataManager.shared.fetchVinylBox()
        if vinylBoxes.count%9 == 0 {
            totalPageNumber = vinylBoxes.count/9
        }else {
            totalPageNumber = vinylBoxes.count/9+1
        }
        reverseVinylBoxes = vinylBoxes.reversed()
    }

    func getPagingVinylBoxItems(indexPath: IndexPath) -> [VinylBox] {
        reverseVinylBoxes.enumerated().filter {
            [weak self] (index: Int, element: VinylBox) -> Bool in
            guard let pageNumber = totalPageNumber else { return false }
            if indexPath.row != pageNumber-1 {
                return (indexPath.row*9 <= index && index <= ((indexPath.row+1)*9-1))
            }else {
                return (indexPath.row*9 <= index && index <= vinylBoxes.count-1)
            }
        }.map { (index: Int, element: VinylBox) -> VinylBox in
            return element
        }
    }

    func getTotalVinylBoxCount() -> Int {
        guard let totalVinylCount = CoreDataManager.shared.getCountVinylBoxData() else { return 0 }
        return totalVinylCount
    }
}
