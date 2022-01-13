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

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    private(set) var isDeletedSpecificVinyl: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    private lazy var backgroundContext: NSManagedObjectContext = {
        guard let myAppDelegate = appDelegate else {
            return NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        }
        let newbackgroundContext = myAppDelegate.persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    
    func saveVinylBox(songTitle: String, singer: String, vinylImage: Data) {

//        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.performBackgroundTask{ [weak self] _ in
//            do {//Background 실행됨
//                let vinylBoxInstance = VinylBox(context: (self?.backgroundContext)!)
//                vinylBoxInstance.signer = singer
//                vinylBoxInstance.songTitle = songTitle
//                vinylBoxInstance.vinylImage = vinylImage
//                if Thread.isMainThread {
//                    print("Save: MainThread")
//                }else {
//                    print("Save: BackgroundThread")
//                }
//                try self?.backgroundContext.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        backgroundContext.perform { [weak self] in
            do {
                guard let myBackgroundContext = self?.backgroundContext else {
                    return
                }
                let vinylBoxInstance = VinylBox(context: myBackgroundContext)
                vinylBoxInstance.signer = singer
                vinylBoxInstance.songTitle = songTitle
                vinylBoxInstance.vinylImage = vinylImage
                if Thread.isMainThread {
                    print("Save: MainThread")
                }else {
                    print("Save: BackgroundThread")
                }
                try self?.backgroundContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImage(data: Data) {

        do {
            let imageInstance = MyImage(context: context ?? backgroundContext)
            imageInstance.favoriteImage = data
            imageInstance.imageID = "name1"

            try context?.save()
            print("MyImage is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchVinylBox() -> [VinylBox] {
        var fetchVinylBox = [VinylBox]()

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VinylBox")
            fetchVinylBox = try context?.fetch(fetchRequest) as! [VinylBox]
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

        do {
            fetchVinylBox = try context?.fetch(fetchRequest) as! [VinylBox]
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
            fetchingImage = try context?.fetch(fetchRequest) as! [MyImage]
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchingImage
    }
    
    func delete(imageID: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyImage")
        fetchRequest.predicate = NSPredicate(format: "imageID = %@", imageID)
        
        do {
            let results = try context?.fetch(fetchRequest) as! [NSManagedObject]
            // Delete _all_ objects:
            for object in results {
                context?.delete(object)
            }
            
            print("CoreData object 수:\(results.count)")
            // Or delete first object: , 처음 1번만 오브젝트삭제됨
            //            if results.count > 0 {
            //                context.delete(results[0])
            //            }
            for object in results {
                print("oject \(object)")
            }
            try context?.save() // data 추가 삭제후 필수로
            
        } catch {
            print("Error while delete func")
            print(error.localizedDescription)
        }
    }
    func deleteSpecificVinylBox(songTitle: String) {

        isDeletedSpecificVinyl.onNext(false)

        backgroundContext.perform { [weak self] in
            do {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "VinylBox")
                fetchRequest.predicate = NSPredicate(format: "songTitle = %@", songTitle)
                let results = try self?.backgroundContext.fetch(fetchRequest) as! [NSManagedObject]
                // Delete _all_ objects:
                for object in results {
                    self?.backgroundContext.delete(object)
                }
                try self?.backgroundContext.save() // data 추가 삭제후 필수로

                if Thread.isMainThread {
                    print("deleteSpecificVinylBox: MainThread")
                }else {
                    print("deleteSpecificVinylBox: BackGroundThread")
                }
                self?.isDeletedSpecificVinyl.onNext(true)

            } catch {
                print("Error delete specific func")
                print(error.localizedDescription)
            }
        }
    }
    func clearAllObjectEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        backgroundContext.perform { [weak self] in
            do {
                if Thread.isMainThread {
                    print("clearAllObjectEntity: MainThread")
                }else {
                    print("clearAllObjectEntity: BackgroundThread")
                }
                try self?.backgroundContext.execute(deleteRequest)
                try self?.backgroundContext.save()
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
        do { let myImage = try context?.fetch(MyImage.fetchRequest()) as! [MyImage]
            print("Data 출력")
            myImage.forEach { print($0.favoriteImage)
                print($0.imageID)
            } }
        catch { print(error.localizedDescription)
        }
    }
    
    func printVinylBoxData() {
        do { let vinylBox = try context?.fetch(VinylBox.fetchRequest()) as! [VinylBox]
            print("Data 출력")
            vinylBox.forEach { //print($0.vinylImage)
                print($0.songTitle)
                print($0.signer)
            } }
        catch { print(error.localizedDescription)
        }
    }
    
    func getCountVinylBoxData() -> Int? {
        do { let vinylBox = try context?.fetch(VinylBox.fetchRequest()) as! [VinylBox]
            return vinylBox.count
        }
        catch { print(error.localizedDescription)
        }
        return nil
    }
}
