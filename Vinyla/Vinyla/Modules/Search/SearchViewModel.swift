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
    var searchModel: BehaviorSubject<[SearchModel]> { get }
    var isSearch: PublishSubject<Bool> { get }
    var moviesData: BehaviorSubject<MovieModel> { get }

    var searchAPIService: VinylAPIServiceProtocol { get set }
}

final class SearchViewModel {
    //Input
    var orderNumber: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    //Output
    var moviesData: BehaviorSubject<[MovieModel]> = BehaviorSubject<[MovieModel]>(value: [])
    var searchAPIService: VinylAPIServiceProtocol
    var isSearch: PublishSubject<Bool> = PublishSubject<Bool>()

    init(searchAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.searchAPIService = searchAPIService

        _ = orderNumber
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(true) })
            .flatMapLatest{ order -> Observable<[MovieModel]> in
                print("flatmap", order)
                return self.searchAPIService.getMovies(order: order)
            }
            .do(onNext: { [weak self] _ in self?.isSearch.onNext(false) })
            .bind(to: moviesData)
//            .flatMapLatest { name -> Observable<[GitRepository]> in
//                return self.githubService.searchRepos(of: name)
//            }
//            .do(onNext: { [weak self] _ in self?.searching.onNext(false) })
//            .bind(to: gitRepository)
    }
    func printCellIndexPath(cell: SearchTableViewCell) {
        print(cell)
    }
}
