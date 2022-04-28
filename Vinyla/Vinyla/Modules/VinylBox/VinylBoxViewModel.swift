//
//  VinylBoxViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift

final class VinylBoxViewModel {

    var vinylBoxes = [VinylBox]()
    var reverseVinylBoxes = [VinylBox]()

    var totalPageNumber: Int?
    var nowPageNumber: Int
    private(set) var isDeletedVinylData = PublishSubject<Bool>()
    private(set) var vinylTotalCount = PublishSubject<Int>()
    private var disposeBag = DisposeBag()

    init() {
        CoreDataManager.shared.isDeletedSpecificVinyl
            .bind(to: isDeletedVinylData)
            .disposed(by: disposeBag)

        self.nowPageNumber = 1

    }

    var pageString: String {
        return "다음 서랍 \(self.nowPageNumber)/\(self.totalPageNumber ?? 1)"
    }

    func updateVinylBoxesAndReversBoxes() {
        vinylBoxes = CoreDataManager.shared.fetchVinylBox()
        if vinylBoxes.count%9 == 0 {
            totalPageNumber = vinylBoxes.count/9
        }else {
            totalPageNumber = vinylBoxes.count/9+1
        }
        reverseVinylBoxes = vinylBoxes.reversed()
    }

    func updatePageNumber() {

        guard let totalPageNumber = self.totalPageNumber else {
            return
        }

        if nowPageNumber > totalPageNumber {
            self.nowPageNumber -= 1
        }
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

    func getTotalVinylBoxCountObservable() -> Observable<Int> {
        guard let totalVinylCount = CoreDataManager.shared.getCountVinylBoxData() else { return Observable<Int>.create() { emiter in
            emiter.onNext(0)
            return Disposables.create()
        } }

        return Observable<Int>.create() { emiter in
            emiter.onNext(totalVinylCount)
            return Disposables.create()
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
