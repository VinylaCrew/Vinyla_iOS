//
//  HomeViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation

class HomeViewModel {
    var homeStirng: String?
    private(set) var recentVinylBoxData: [VinylBox]?
    init() {
        
    }
    
    deinit {
        print("deinit HomeViewModel")
    }
    
    func fetchRecentVinylData() {
        self.recentVinylBoxData = CoreDataManager.shared.fetchRecentVinylBox()
    }
    
    func getRecentVinylBoxData(indexPathRow: Int) -> Data? {
        if let check = self.recentVinylBoxData, indexPathRow < check.count {
            return check[indexPathRow].vinylImage
        }else {
            return nil
        }
    }
    func getTotalVinylBoxCount() -> Int {
        guard let totalVinylCount = CoreDataManager.shared.getCountVinylBoxData() else { return 0 }
        return totalVinylCount
    }
    
    func getLevelGague() -> String {
        let totalVinylCount = self.getTotalVinylBoxCount()
        switch totalVinylCount {
        case 0:
            return "\(totalVinylCount)/1"
        case 1...9:
            return "\(totalVinylCount)/9"
        case 10...49:
            return "\(totalVinylCount)/49"
        case 50...499:
            return "\(totalVinylCount)/499"
        default:
            return "\(totalVinylCount)/"
        }
    }
}
