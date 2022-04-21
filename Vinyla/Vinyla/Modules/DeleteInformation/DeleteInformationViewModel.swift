//
//  DeleteInformationViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/18.
//

import Foundation
import RxSwift

final class DeleteInformationViewModel {
    var model: AddInformationModel
    var vinylID: Int64?
    var songTitle: String?
    var vinylInformationService: VinylAPIServiceProtocol
    var vinylInformationDataModel: VinylInformation.Data?
    var vinylInformationData: PublishSubject<VinylInformation.Data?> = PublishSubject<VinylInformation.Data?>()

    var disposeBag = DisposeBag()

    init(vinylInformationService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.model = AddInformationModel()
        self.vinylInformationService = vinylInformationService
    }

    func deleteVinylBoxData() {
        guard let deleteSong = songTitle else { return }
        if Thread.isMainThread {
            print("vm call deleteVinylBoxData: MainThread")
        }else {
            print("vm call deleteVinylBoxData: BackGroundThread")
        }
        CoreDataManager.shared.deleteSpecificVinylBox(songTitle: deleteSong)
    }

    func updateMainFavoriteVinylImage(isButtonSelected: Bool,imageData: Data) {
        print("favorite func vm", isButtonSelected)
    }

    func fetchVinylInformation() {
//        model.vinylID = CoreDataManager.shared.
        guard let vinylID = vinylID else {
            return
        }

        self.vinylInformationService.requestVinylDetail(vinylID: Int(vinylID))
            .do(onNext:{ [weak self] data in
                self?.vinylInformationDataModel = data
            })
            .bind(to: vinylInformationData)
            .disposed(by: disposeBag)
    }
}
