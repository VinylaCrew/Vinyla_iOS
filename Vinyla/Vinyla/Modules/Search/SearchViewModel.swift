//
//  SearchViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift

protocol SearchViewModelType {
    //Input
    var vinylName: PublishSubject<String> { get }
    var orderNumber: BehaviorSubject<String> { get }

    //Output
    var vinylsData: BehaviorSubject<[SearchModel.Data?]> { get }
    var isSearch: PublishSubject<Bool> { get }
    var vinylsCount: BehaviorSubject<String?> { get set }

    var searchAPIService: VinylAPIServiceProtocol { get set }
}

final class SearchViewModel: SearchViewModelType {
    //Input
    var vinylName: PublishSubject<String> = PublishSubject<String>()
    var orderNumber: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    //Output
    public private(set) var vinylsData: BehaviorSubject<[SearchModel.Data?]> = BehaviorSubject<[SearchModel.Data?]>(value: [])
    var vinylsCount: BehaviorSubject<String?> = BehaviorSubject<String?>(value: "0")
    var searchAPIService: VinylAPIServiceProtocol
    var isSearch: PublishSubject<Bool> = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    init(searchAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.searchAPIService = searchAPIService
        let testAPIService = MockAPIService()

        _ = vinylName
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(true) })
            .flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data?]> in
                print("vinylName vimodel test:",vinyl)
                return self.searchAPIService.searchVinyl(vinylName: vinyl)
                //return testAPIService.searchVinyl(vinylName: vinyl)
            }
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(false) })
            .bind(to: vinylsData)
            .disposed(by: disposeBag)

        _ = vinylsData
            .map({ String($0.count) })
            .bind(to: vinylsCount)
            .disposed(by: disposeBag)

    }
    deinit {
        print("search viewmodel deinit")
    }
    func printCellIndexPath(cell: SearchTableViewCell) {
        print(cell)
    }
}
