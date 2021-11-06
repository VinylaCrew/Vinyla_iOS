//
//  AddInformationViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/06.
//

import Foundation
import RxSwift

class AddInformationViewModel {
    var model: AddInformationModel
    var vinylInformationData: BehaviorSubject<VinylInformation.Data?> = BehaviorSubject<VinylInformation.Data?>(value: nil)
    var vinylInformationService: VinylAPIServiceProtocol

    var disposeBag = DisposeBag()
    init(vinylInformationService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.model = AddInformationModel()
        self.vinylInformationService = vinylInformationService

        _ = self.vinylInformationService.getVinylDetail(vinylID: 2865072)
            .bind(to: vinylInformationData)
//            .bind(to: vinylInformationData)
    }

    func fetchVinylInformation() {
        print("hihi")
        self.vinylInformationService.getVinylDetail(vinylID: 18048907)
            .subscribe(onNext: { data in
                print("fetch",data!)
            })
            .disposed(by: disposeBag)
    }
}
