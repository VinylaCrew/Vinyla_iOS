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
    var vinylInformationDataModel: VinylInformation.Data?
    var vinylInformationData: PublishSubject<VinylInformation.Data?> = PublishSubject<VinylInformation.Data?>()
    var vinylInformationService: VinylAPIServiceProtocol

    var disposeBag = DisposeBag()
    init(vinylInformationService: VinylAPIServiceProtocol = VinylAPIService()) {
        print("information vm init()")
        self.model = AddInformationModel()
        self.vinylInformationService = vinylInformationService

        print("init()", model.vinylID)
//        _ = self.vinylInformationService.getVinylDetail(vinylID: model.vinylID)
//            .bind(to: vinylInformationData)
//            .disposed(by: disposeBag)
    }

    func fetchVinylInformation() {
        print(self.model.vinylID)
        
        self.vinylInformationService.requestVinylDetail(vinylID: model.vinylID)
            .do(onNext:{ [weak self] data in
                self?.vinylInformationDataModel = data
            })
            .bind(to: vinylInformationData)
            .disposed(by: disposeBag)

    }
}
