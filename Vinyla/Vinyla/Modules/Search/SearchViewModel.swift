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
    var vinylName: BehaviorSubject<String> { get }
    var orderNumber: BehaviorSubject<String> { get }

    //Output
    var vinylsData: BehaviorSubject<[SearchModel.Data?]> { get }
    var isSearch: PublishSubject<Bool> { get }
    var moviesData: BehaviorSubject<MovieModel.Data?> { get }

    var searchAPIService: VinylAPIServiceProtocol { get set }
}

final class SearchViewModel {
    //Input
    var vinylName: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var orderNumber: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    //Output
    var moviesData: BehaviorSubject<[MovieModel.Data?]> = BehaviorSubject<[MovieModel.Data?]>(value: [])
    public private(set) var vinylsData: BehaviorSubject<[SearchModel.Data?]> = BehaviorSubject<[SearchModel.Data?]>(value: [])
    var vinylsCount: BehaviorSubject<String?> = BehaviorSubject<String?>(value: "")
    var searchAPIService: VinylAPIServiceProtocol
    var isSearch: PublishSubject<Bool> = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    init(searchAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.searchAPIService = searchAPIService

        _ = vinylName
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(true) })
            .flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data?]> in
                print("vimodel test",vinyl)
                return self.searchAPIService.searchVinyl(vinylName: vinyl)
            }
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(false) })
            .bind(to: vinylsData)
            .disposed(by: disposeBag)

        _ = vinylName
            .flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data?]> in
                print("vimodel test",vinyl)
                return self.searchAPIService.searchVinyl(vinylName: vinyl)
            }
            .map{
                return String($0.count)
            }
            .bind(to: vinylsCount)
            .disposed(by: disposeBag)


//        _ = orderNumber
//            .do(onNext: { [weak self] _ in self?.isSearch.onNext(true) })
//            .flatMapLatest{ order -> Observable<[MovieModel.Data?]> in
//                print("flatmap order:", order)
//                return self.searchAPIService.getMovies(order: order)
//            }
//            .do(onNext: { [weak self] _ in self?.isSearch.onNext(false) })
//            .bind(to: moviesData)
    }
    func printCellIndexPath(cell: SearchTableViewCell) {
        print(cell)
    }
}
