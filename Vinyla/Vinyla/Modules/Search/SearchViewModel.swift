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
    var vinylsData: PublishSubject<[SearchModel.Data]?> { get }
    var isSearch: PublishSubject<Bool> { get }
    var vinylsCount: BehaviorSubject<String?> { get set }
    var userSearchText: BehaviorSubject<String> { get set }

    var searchAPIService: VinylAPIServiceProtocol { get set }
}

final class SearchViewModel: SearchViewModelType {
    //Input
    var vinylName: PublishSubject<String> = PublishSubject<String>()
    var orderNumber: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    //Output
    public private(set) var vinylsData: PublishSubject<[SearchModel.Data]?> = PublishSubject<[SearchModel.Data]?>()
    public internal(set) var userSearchText: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var vinylsCount: BehaviorSubject<String?> = BehaviorSubject<String?>(value: "0")
    var searchAPIService: VinylAPIServiceProtocol
    var isSearch: PublishSubject<Bool> = PublishSubject<Bool>()
    var disposeBag = DisposeBag()

    init(searchAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.searchAPIService = searchAPIService
        let testAPIService = MockAPIService()

        _ = vinylName
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(true) })
            .flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data]?> in
                print("vinylName vimodel test:",vinyl)
                return self.searchAPIService.requestSearchVinyl(vinylName: vinyl)
                //return testAPIService.searchVinyl(vinylName: vinyl)
            }
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(false) })
            .bind(to: vinylsData)
            .disposed(by: disposeBag)

                _ = vinylsData
                .map({ data -> String in
                    if let data = data {
                        return String(data.count)
                    }else {
                        return String(0)
                    }
                })
                .bind(to: vinylsCount)
                .disposed(by: disposeBag)

                _ = vinylName
                .subscribe(onNext:{ [weak self] text in
                    if text.count <= 9 {
                        self?.userSearchText.onNext(text)
                    }else {
                        self?.userSearchText.onNext(String(text.prefix(8)) + "...")
                    }
                })
                .disposed(by: disposeBag)

    }
    deinit {
        print("search viewmodel deinit")
    }
    func printCellIndexPath(cell: SearchTableViewCell) {
        print(cell)
    }
}
