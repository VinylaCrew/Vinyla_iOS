//
//  CoreDataManager.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/06.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        
        let imageInstance = MyImage(context: context)
        imageInstance.favoriteImage = data
        imageInstance.imageID = "name1"
        do {
            try context.save()
            print("MyImage is saved")
        } catch {
            print(error.localizedDescription)
        }
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

            print(results.count)
            // Or delete first object: , 처음 1번만 오브젝트삭제됨
//            if results.count > 0 {
//                context.delete(results[0])
//            }
        } catch {
            print("Error while delete")
        }
         
    }

    
    
    func printData() {
            do { let myImage = try context.fetch(MyImage.fetchRequest()) as! [MyImage]
                myImage.forEach { print($0.favoriteImage)
                    print($0.imageID)
                    print("Data 출력") } }
            catch { print(error.localizedDescription)
                print("에러뤄")
            }
    }
}
