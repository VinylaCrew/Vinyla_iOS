//
//  HomeViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift

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

    func getLevelName() -> Observable<String?> {
        let totalVinylCount = self.getTotalVinylBoxCount()
        switch totalVinylCount {
        case 0:
            return Observable.just("닐페이스")
        case 1...9:
            return Observable.just("닐리즈")
        case 10...49:
            return Observable.just("닐스터")
        case 50...499:
            return Observable.just("닐암스트롱")
        default:
            return Observable.just("닐라대왕")
        }
    }

    func getLevelGagueWidth(screenSize: CGFloat) -> CGFloat {
        let widthSize = screenSize - CGFloat(30)
        let totalVinylCount = self.getTotalVinylBoxCount()
        switch totalVinylCount {
        case 0:
            return CGFloat(0)
        case 1...9:
            return CGFloat((widthSize/9.0) * CGFloat(totalVinylCount))
        case 10...49:
            return CGFloat((widthSize/49.0) * CGFloat(totalVinylCount))
        case 50...499:
            return CGFloat((widthSize/499.0) * CGFloat(totalVinylCount))
        default:
            return widthSize
        }
    }

    func getLevelImageName() -> String {
        let totalVinylCount = self.getTotalVinylBoxCount()
        switch totalVinylCount {
        case 0:
            return "icnHomeLv1"
        case 1...9:
            return "icnHomeLv2"
        case 10...49:
            return "icnHomeLv3"
        case 50...499:
            return "icnHomeLv4"
        default:
            return "icnHomeLv5"
        }
    }
}
