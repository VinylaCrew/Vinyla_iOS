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
    var myVinylSyncData: PublishSubject<Data> { get }
    var myUserSyncData: PublishSubject<String> { get }
    var myGenre: PublishSubject<String> { get }
//    var myVinyl: (() -> Data?) { get set }

    //func
    func fetchRecentVinylData()
    func getRecentVinylBoxData(indexPathRow: Int) -> Data?
    func getTotalVinylBoxCount() -> Int
    func getLevelGague() -> String
    func getLevelName() -> Observable<String?>
    func getLevelGagueWidth(screenSize: CGFloat) -> CGFloat
    func getLevelImageName() -> String
    func requestServerVinylBoxData() -> Void
    func myVinyl() -> Data?
    func requestMyGenre()
}

final class HomeViewModel: HomeViewModelProtocol {

    private(set) var recentVinylBoxData: [VinylBox]?
    var isSyncVinylBox: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    var myVinylSyncData: PublishSubject<Data> = PublishSubject<Data>()
    var myUserSyncData: PublishSubject<String> = PublishSubject<String>()
    var myGenre: PublishSubject<String> = PublishSubject<String>()
//    var myVinyl: Data? {
//        let myVinylImage = CoreDataManager.shared.fetchImage()
//        if !myVinylImage.isEmpty {
//            if let myVinylImageData = myVinylImage[0].favoriteImage {
//                return myVinylImageData
//            }
//        }
//        return nil
//    }

    var homeAPIService: VinylAPIServiceProtocol?
    var disposeBag = DisposeBag()
    init(homeAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.homeAPIService = homeAPIService

    }
    
    deinit {
        print("deinit HomeViewModel")
    }

    func requestServerVinylBoxData() {
        guard let isFirstLogin = VinylaUserManager.isFirstLogin else { return }
        let dispatchGroup = DispatchGroup()
        
        if isFirstLogin {
            _ = self.homeAPIService?.requestVinylBoxMyData()
//                .do(onNext: { [weak self] _ in
//                    print("do do")
//                        self?.isSyncVinylBox.onNext(true)
//                })
//                .delay(.seconds(1), scheduler: MainScheduler.instance)
                .retry(3)
                .subscribe(onNext:{ [weak self] data in
                    CoreDataManager.shared.clearAllObjectEntity("VinylBox")
                    print("내부데이터 전체 삭제 + Thread",Thread.isMainThread)
                    guard let myVinylData = data?.myVinyls else { return }
                    print(myVinylData)

                    for item in myVinylData {//역순으로오면 , 여기서 역순으로 코어데이터에 저장하면 기존 로직 변경하지않아도됨
                        
                        if let myVinylImageURL = item.imageURL {

                            dispatchGroup.enter()
                            DispatchQueue.global().async() {
                                guard let insideImageURL = URL(string: myVinylImageURL) else { return }
                                let dataTask = URLSession.shared.dataTask(with: insideImageURL) { (data, result, error) in
                                    guard error == nil else {
                                        dispatchGroup.leave()
                                        return
                                    }

                                    if let data = data, let vinylImage = UIImage(data: data) {
                                        print("데이터 VM 저장 호출(이미지URL ON)",item.title,vinylImage)
                                        CoreDataManager.shared.saveVinylBoxWithDispatchGroup(
                                            uniqueIndex: Int64(item.vinylIdx),
                                            vinylIndex: Int64(item.timestampIdx),
                                            vinylID: Int64(item.id),
                                            songTitle: item.title,
                                            singer: item.artist,
                                            vinylImage: vinylImage.jpegData(compressionQuality: 1)!,
                                            dispatchGroup: dispatchGroup
                                        )
                                    }else {//썸네일 URL은 있으나, 이미지 변경 등의 이유로 삭제된 경우
                                        print("thumbnail image doesn't exist error")
                                        dispatchGroup.leave()
                                    }
                                }

                                dataTask.resume()
                            }

                        } else {//썸네일 이미지 없는 경우
                            guard let baseImage = UIImage(named: "my")?.jpegData(compressionQuality: 0.1) else { return }
                            print("데이터 VM 저장 호출(이미지URL OFF)",item.title)
                            CoreDataManager.shared.saveVinylBoxWithIndex(vinylIndex: Int64(item.vinylIdx), songTitle: item.title, singer: item.artist, vinylImage: baseImage)
                        }
                        
                        /// 바이닐 저장시 다음 저장 인덱스 계산을 위해서 필요
                        VinylaUserManager.userVinylIndex = max(VinylaUserManager.userVinylIndex ?? 0, item.timestampIdx)
                        
                    }

                    dispatchGroup.notify(queue: .global()) {
                        print("홈 VM SyncVinylBox: false 호출")
                        self?.isSyncVinylBox.onNext(false)
                        VinylaUserManager.isFirstLogin = false
                    }

                }, onError: { [weak self] error in
                    self?.isSyncVinylBox.onNext(false)
                })
                .disposed(by: disposeBag)

            //MARK: ToDo 최초 로그인시 마이바이닐 및 장르 설정 (홈화면 조회 API)
            let checkAPITarget = APITarget.checkHomeInformation
            CommonNetworkManager.request(apiType: checkAPITarget)
                .subscribe(onSuccess: { (response: CheckHomeInformationResponse) in
                    print(response)
                    if let user = response.data.userInfo {
                        print("nickname",user[0].nickname)
                        VinylaUserManager.nickname = user[0].nickname
                        self.myUserSyncData.onNext(user[0].nickname)
                    }
                    
                    if let myVinyl = response.data.myVinyl {
                        VinylaUserManager.myVInylIndex = myVinyl.vinylIdx
                        DispatchQueue.global().async() {
                            guard let insideImageURL = URL(string: myVinyl.imageURL) else { return }
                            let dataTask = URLSession.shared.dataTask(with: insideImageURL) { (imageData, result, error) in
                                guard let imageData = imageData else { return }
                                CoreDataManager.shared.clearAllObjectEntity("MyImage")
                                let dispatchGroup = DispatchGroup()
                                dispatchGroup.enter()
                                CoreDataManager.shared.saveImageWithDispatchGroup(data: imageData, dispatchGroup: dispatchGroup)
                                dispatchGroup.notify(queue: .global()) {
                                    self.myVinylSyncData.onNext(imageData)
                                }
                            }
                            dataTask.resume()
                        }
                    } else {
                        VinylaUserManager.myVInylIndex = -1
                        CoreDataManager.shared.clearAllObjectEntity("MyImage")
                    }
                }, onError: { error in
                    print(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func requestMyGenre() {
        let checkHomeAPITarget = APITarget.checkHomeInformation
        CommonNetworkManager.request(apiType: checkHomeAPITarget)
            .subscribe(onSuccess: { [weak self] (response: CheckHomeInformationResponse) in
                guard let genre = response.data.genreInfo else { return }
                self?.myGenre.onNext(genre.first ?? "")
            })
            .disposed(by: disposeBag)
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

    func myVinyl() -> Data? {
        let myVinylImage = CoreDataManager.shared.fetchImage()
        if !myVinylImage.isEmpty {
            if let myVinylImageData = myVinylImage[0].favoriteImage {
                return myVinylImageData
            }
        }
        return nil
    }

    func getTotalVinylBoxCount() -> Int {
        guard let totalVinylCount = CoreDataManager.shared.getCountVinylBoxData() else { return 0 }
        return totalVinylCount
    }
    
    func getLevelGague() -> String {
        let totalVinylCount = self.getTotalVinylBoxCount()
        switch totalVinylCount {
        case 0...1:
            return "\(totalVinylCount)/1"
        case 2...9:
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
        case 0...1:
            return Observable.just("닐페이스")
        case 2...9:
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
        case 2...9:
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
        case 0...1:
            return "icnHomeLv1"
        case 2...9:
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
