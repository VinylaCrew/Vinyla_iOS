//
//  AddInformationViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/06.
//

import Foundation
import RxSwift

final class AddInformationViewModel {
    var model: AddInformationModel
    var isDeleteMode: Bool?
    //vinyl 상세 데이터 정보 (Server 바이닐 저장 Request에 필요 정보)
    var vinylInformationDataModel: VinylInformation.Data?
    var vinylInformationData: PublishSubject<VinylInformation.Data?> = PublishSubject<VinylInformation.Data?>()
    var vinylInformationService: VinylAPIServiceProtocol

    var disposeBag = DisposeBag()
    init(vinylInformationService: VinylAPIServiceProtocol = VinylAPIService()) {
        print("information vm init()")
        self.model = AddInformationModel()
        self.vinylInformationService = vinylInformationService

//        _ = self.vinylInformationService.getVinylDetail(vinylID: model.vinylID)
//            .bind(to: vinylInformationData)
//            .disposed(by: disposeBag)
    }

    func fetchVinylInformation() {
        print("model.viynlID: ",self.model.vinylID)
        
        self.vinylInformationService.requestVinylDetail(vinylID: model.vinylID)
            .do(onNext:{ [weak self] data in
                self?.vinylInformationDataModel = data
            })
            .bind(to: vinylInformationData)
            .disposed(by: disposeBag)
    }

    func deleteVinylBoxData(deleteDispatchGroup: DispatchGroup) {
        print("deleteVinylBoxData")
        guard let vinylID = model.vinylID else { return }
        let vinylDeleteAPI = APITarget.deleteVinyl(vinylID: vinylID)

        CommonNetworkManager.request(apiType: vinylDeleteAPI)
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onSuccess: { (response: DeleteVinylResponse) in
                guard response.data != nil else {
                    deleteDispatchGroup.leave()
                    return
                }

                print(response)
                CoreDataManager.shared.deleteVinyl(vinylID: Int64(vinylID), dispatchGroup: deleteDispatchGroup)
            }, onError: { error in
                print(error)
                deleteDispatchGroup.leave()
            })
            .disposed(by: disposeBag)

    }

    func requestRegisterMyVinyl(dispatchGroup: DispatchGroup) {
        guard let vinylIndex = model.vinylIndex else { return }
        let myVinylData = MyVinylRequest(vinylIdx: vinylIndex)
        let registerMyVinylAPI = APITarget.registerMyVinyl(vinylData: myVinylData)

        CommonNetworkManager.request(apiType: registerMyVinylAPI)
            .subscribe(onSuccess: { (response: MyVinylResponse) in
                print(response)
                if response.message == "대표 바이닐 설정 성공" {
                    VinylaUserManager.myVInylIndex = vinylIndex
                }
                if response.message == "대표 바이닐 취소 성공" {
                    VinylaUserManager.myVInylIndex = -1
                    CoreDataManager.shared.clearAllObjectEntity("MyImage")
                }
                dispatchGroup.leave()
            }, onError: { error in
                print("Error Log: ",error)
            })
            .disposed(by: disposeBag)
    }

    func saveMyVinylCoreData(myVinylData: Data) {
        CoreDataManager.shared.clearAllObjectEntity("MyImage")
        CoreDataManager.shared.saveImage(data: myVinylData) 
    }
}
