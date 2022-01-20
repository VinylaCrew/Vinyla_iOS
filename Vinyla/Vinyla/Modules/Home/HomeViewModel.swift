//
//  HomeViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation
import RxSwift

protocol HomeViewModelProtocol {

    //output
    var recentVinylBoxData: [VinylBox]? { get }
    var isSyncVinylBox: BehaviorSubject<Bool> { get }
    //func
    func fetchRecentVinylData()
    func getRecentVinylBoxData(indexPathRow: Int) -> Data?
    func getTotalVinylBoxCount() -> Int
    func getLevelGague() -> String
    func getLevelName() -> Observable<String?>
    func getLevelGagueWidth(screenSize: CGFloat) -> CGFloat
    func getLevelImageName() -> String
}

final class HomeViewModel: HomeViewModelProtocol {
    private(set) var recentVinylBoxData: [VinylBox]?
    var isSyncVinylBox: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)

    var homeAPIService: VinylAPIServiceProtocol?
    var disposeBag = DisposeBag()
    init(homeAPIService: VinylAPIServiceProtocol = MockAPIService()) {
        self.homeAPIService = homeAPIService

        let isFirstLogin = UserDefaults.standard.bool(forKey: "isFirstLogin")

        if isFirstLogin {
            _ = homeAPIService.getVinylBoxMyData()
//                .do(onNext: { [weak self] _ in
//                        self?.isSyncVinylBox.onNext(true)
//                })
//                .delay(.seconds(3), scheduler: MainScheduler.instance)
                .subscribe(onNext:{ [weak self] data in
                    CoreDataManager.shared.clearAllObjectEntity("VinylBox")
                    print("내부데이터 전체 삭제 + Thread",Thread.isMainThread)
                    guard let myVinylData = data?.myVinyls else { return }
                    print(myVinylData)

                    let dispatchGroup = DispatchGroup()

                    for item in myVinylData {//역순으로오면 , 여기서 역순으로 코어데이터에 저장하면 기존 로직 변경하지않아도됨
                        guard let myItem = item else { return }
                        if let myVinylImageURL = myItem.imageURL {

                            dispatchGroup.enter()
                            DispatchQueue.global().async(group: dispatchGroup) {
                                guard let insideImageURL = URL(string: myVinylImageURL) else { return }
                                let dataTask = URLSession.shared.dataTask(with: insideImageURL) { (data, result, error) in
                                    guard error == nil else {
                                        dispatchGroup.leave()
                                        return
                                    }

                                    if let data = data, let vinylImage = UIImage(data: data) {
                                        print("데이터 VM 저장 호출(이미지URL ON)",myItem.title,vinylImage)
                                        CoreDataManager.shared.saveVinylBox2(vinylIndex: Int32(myItem.vinylIdx), songTitle: myItem.title, singer: myItem.artist, vinylImage: vinylImage.jpegData(compressionQuality: 1)!)
                                        dispatchGroup.leave()
                                    }
                                }

                                dataTask.resume()
                            }

                        }else {
                            guard let baseImage = UIImage(named: "my")?.jpegData(compressionQuality: 0.1) else { return }
                            print("데이터 VM 저장 호출(이미지URL OFF)",myItem.title)

                            CoreDataManager.shared.saveVinylBox2(vinylIndex: Int32(myItem.vinylIdx), songTitle: myItem.title, singer: myItem.artist, vinylImage: baseImage)
                        }
                    }

                    dispatchGroup.notify(queue: .global()) {
                        UserDefaults.standard.setValue(false, forKey: "isFirstLogin")
                        print("홈 VM SyncVinylBox: false 호출")
                        self?.isSyncVinylBox.onNext(false)
                    }

                }, onError: { [weak self] error in
                    self?.isSyncVinylBox.onNext(false)
                })
                .disposed(by: disposeBag)
        }

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
