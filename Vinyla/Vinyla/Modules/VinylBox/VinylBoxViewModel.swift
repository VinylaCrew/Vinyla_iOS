//
//  VinylBoxViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation

final class VinylBoxViewModel {
    func getTotalVinylBoxCount() -> Int {
        guard let totalVinylCount = CoreDataManager.shared.getCountVinylBoxData() else { return 0 }
        return totalVinylCount
    }
}
