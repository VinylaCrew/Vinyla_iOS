//
//  CoreDataManager.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/06.
//

import UIKit
import CoreData
import RxSwift

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MARK: - UI Update and Data Fetch Main Thread
    private lazy var context = self.appDelegate.persistentContainer.viewContext
    //MARK: - Data Save and Delete Unique Background Thread
    private lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = self.appDelegate.persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    private(set) var isDeletedSpecificVinyl: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private(set) var isSavedSpecificVinyl: Bool = false

    func saveVinylBoxWithIndex(vinylIndex: Int64, songTitle: String, singer: String, vinylImage: Data) {

        backgroundContext.perform { [weak self] in

            do {
                guard let myBackgroundContext = self?.backgroundContext else {
                    return
                }
                let vinylBoxInstance = VinylBox(context: myBackgroundContext)
                vinylBoxInstance.index = vinylIndex
                vinylBoxInstance.singer = singer
                vinylBoxInstance.songTitle = songTitle
                vinylBoxInstance.vinylImage = vinylImage

                try self?.backgroundContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveVinylBoxWithDispatchGroup(uniqueIndex: Int64, vinylIndex: Int64, vinylID: Int64, songTitle: String, singer: String, vinylImage: Data, dispatchGroup: DispatchGroup) {

        backgroundContext.perform { [weak self] in

            do {
                guard let myBackgroundContext = self?.backgroundContext else {
                    return
                }
                let vinylBoxInstance = VinylBox(context: myBackgroundContext)
                /// 바이닐 서버에 저장된 고유한 Index
                vinylBoxInstance.uniqueIndex = uniqueIndex
                /// 내부 바이닐 데이터 저장된 Index 순서
                vinylBoxInstance.index = vinylIndex
                vinylBoxInstance.singer = singer
                vinylBoxInstance.songTitle = songTitle
                vinylBoxInstance.vinylImage = vinylImage
                vinylBoxInstance.vinylID = vinylID
                
                if myBackgroundContext.hasChanges {
                    try self?.backgroundContext.save()
                    self?.isSavedSpecificVinyl = true
                    dispatchGroup.leave()
                }
            } catch {
                print("CoreData Error:",error.localizedDescription)
                self?.isSavedSpecificVinyl = false
                dispatchGroup.leave()
            }
        }
        
    }
    
    func saveImage(data: Data) {
        //마이 바이닐 저장
        backgroundContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                if Thread.isMainThread {
                    print("saveImage: MainThread")
                }else {
                    print("saveImage: BackgroundThread")
                }
                let imageInstance = MyImage(context: self.backgroundContext)
                imageInstance.favoriteImage = data
                imageInstance.imageID = "name1"

                try self.backgroundContext.save()
                print("MyImage is saved")
            } catch {
                print("saveImage Error")
                print(error.localizedDescription)
            }
        }

    }
    
    func saveImageWithDispatchGroup(data: Data, dispatchGroup: DispatchGroup) {
        //마이 바이닐 저장
        backgroundContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                
                let imageInstance = MyImage(context: self.backgroundContext)
                imageInstance.favoriteImage = data
                imageInstance.imageID = "name1"
                
                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                    dispatchGroup.leave()
                }
                
            } catch {
                print("saveImage Error")
                dispatchGroup.leave()
                print(error.localizedDescription)
            }
        }

    }

    func deleteImage() {

        do {
            let imageInstance = MyImage(context: backgroundContext)
            imageInstance.favoriteImage = nil
            imageInstance.imageID = nil

            try backgroundContext.save()
            print("MyImage is deleted")
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchVinylBox() -> [VinylBox] {
        var fetchVinylBox = [VinylBox]()
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VinylBox")
            let sortCondition = NSSortDescriptor(key: "index", ascending: true)
            fetchRequest.sortDescriptors = [sortCondition]

            fetchVinylBox = try context.fetch(fetchRequest) as! [VinylBox]

            if Thread.isMainThread {
                print("fetchVinylBox: MainThread")
            }else {
                print("fetchVinylBox: BackGroundThread")
            }
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchVinylBox
    }
    func fetchRecentVinylBox() -> [VinylBox]? {
        var fetchVinylBox = [VinylBox]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VinylBox")
        let sortCondition = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortCondition]

        do {
            fetchVinylBox = try context.fetch(fetchRequest) as! [VinylBox]
        } catch {
            print("Error while fetching the image")
        }
        let recentVinylBox = fetchVinylBox.reversed().enumerated().filter{ (index: Int, item: VinylBox) -> Bool in
            if index < 4 {
                return true
            }else {
                return false
            }
        }.map { (index: Int, item: VinylBox) in //enumerated사용시 map에 클로져 축약형 문법사용시 index offset도 같이 return하게됨.
            return item
        }
        return recentVinylBox
    }
    
    func fetchImage() -> [MyImage] {
        var fetchingImage = [MyImage]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyImage")
        
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [MyImage]
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchingImage
    }
    
    func delete(imageID: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyImage")
        fetchRequest.predicate = NSPredicate(format: "imageID = %@", imageID)
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            // Delete _all_ objects:
            for object in results {
                context.delete(object)
            }
            
            print("CoreData object 수:\(results.count)")
            // Or delete first object: , 처음 1번만 오브젝트삭제됨
            //            if results.count > 0 {
            //                context.delete(results[0])
            //            }
            for object in results {
                print("oject \(object)")
            }
            try context.save() // data 추가 삭제후 필수로
            
        } catch {
            print("Error while delete func")
            print(error.localizedDescription)
        }
    }

    func deleteSpecificVinylBox(songTitle: String) {

        isDeletedSpecificVinyl.onNext(false)

        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            do {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "VinylBox")
                fetchRequest.predicate = NSPredicate(format: "songTitle = %@", songTitle)
                let results = try self.backgroundContext.fetch(fetchRequest) as! [NSManagedObject]
                // Delete _all_ objects:
                for object in results {
                    self.backgroundContext.delete(object)
                }

                if self.backgroundContext.hasChanges {
                    print("data deleted and save()")
                    try self.backgroundContext.save() // data 추가 삭제후 필수로
                }


                if Thread.isMainThread {
                    print("deleteSpecificVinylBox: MainThread")
                }else {
                    print("deleteSpecificVinylBox: BackGroundThread")
                }
                self.isDeletedSpecificVinyl.onNext(true)

            } catch {
                print("Error delete specific func")
                print(error.localizedDescription)
            }
        }
    }

    func deleteVinyl(vinylID: Int64, dispatchGroup: DispatchGroup) {

        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            do {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "VinylBox")
                let nsVinylNumber = NSNumber(value: vinylID)
                fetchRequest.predicate = NSPredicate(format: "vinylID = %i", nsVinylNumber.int64Value)
                let results = try self.backgroundContext.fetch(fetchRequest) as! [NSManagedObject]

                if Thread.isMainThread {
                    print("deleteVinyl: MainThread")
                }else {
                    print("deleteVinyl: BackgroundThread")
                }

                // Delete _all_ objects:
                for object in results {
                    self.backgroundContext.delete(object)
                }

                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save() // data 추가 삭제후 필수로
                    dispatchGroup.leave()
                }

            } catch {
                print(error.localizedDescription)
                dispatchGroup.leave()
            }
        }
    }

    func clearAllObjectEntity(_ entity: String) {
//        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        backgroundContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                if Thread.isMainThread {
                    print("clearAllObjectEntity: MainThread")
                }else {
                    print("clearAllObjectEntity: BackgroundThread")
                }
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                
                try self.backgroundContext.execute(deleteRequest)
                self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }
//                try self.backgroundContext.save()
            } catch {
                print("clearallobject error")
                print(error.localizedDescription)
            }
        }
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//        } catch {
//            print("clearallobject error")
//            print(error.localizedDescription)
//        }
    }
    
    func printData() {
        do { let myImage = try context.fetch(MyImage.fetchRequest()) as! [MyImage]
            print("Data 출력")
            myImage.forEach { print($0.favoriteImage)
                print($0.imageID)
            } }
        catch { print(error.localizedDescription)
        }
    }
    
    func printVinylBoxData() {
        do { let vinylBox = try context.fetch(VinylBox.fetchRequest()) as! [VinylBox]
            print("Data 출력")
            vinylBox.forEach { //print($0.vinylImage)
                print($0.songTitle)
                print($0.singer)
            } }
        catch { print(error.localizedDescription)
        }
    }
    
    func getCountVinylBoxData() -> Int? {
        do { let vinylBox = try context.fetch(VinylBox.fetchRequest()) as! [VinylBox]
            return vinylBox.count
        }
        catch { print(error.localizedDescription)
        }
        return nil
    }
}
