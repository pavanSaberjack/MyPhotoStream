//
//  MPSDataManager.swift
//  MyPhotoStream
//
//  Created by Pavan on 08/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit
import CoreData


class MPSDataManager: NSObject {

    static let sharedInstance: MPSDataManager = MPSDataManager()
    
    override init() {
        super.init()
        
        // customize
    }

    lazy var managedObjectModel: NSManagedObjectModel = {
        let url : URL = Bundle.main.url(forResource: "MyPhotoStream", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    
    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyPhotoStream")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("MyPhotoStream.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
       
        if #available(iOS 10.0, *) {
            return self.persistentContainer.viewContext
        }
        
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    // MARK: - Core Data Saving support
    // completion: @escaping (Bool?) -> Swift.Void
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func getImagesList() -> [MPSImage] {
        let fetchRequest: NSFetchRequest<MPSImage> = MPSImage.fetchRequest()
        let moc = self.managedObjectContext
        do {
            let fetchedEmployees = try moc.fetch(fetchRequest)
            return fetchedEmployees
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }        
    }
    
    func downloadImage(_ imageObj: MPSImage , completion: @escaping (MPSImage?) -> Swift.Void) {
        MPSConnectorManager.sharedInstance.downloadPic(imageObj.downloadURLStr!) { (image, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let moc = self.managedObjectContext
            let fetchRequest: NSFetchRequest<MPSImage> = MPSImage.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "imageId == %s", argumentArray: [imageObj.imageId!])
            
            print(imageObj.imageId ?? "not found")
            print(fetchRequest.predicate?.predicateFormat ?? "not found")
            
            do {
                let fetchedImgObjects = try moc.fetch(fetchRequest) 
                let obj = fetchedImgObjects.first
                
                obj?.image = image
                self.saveContext()
                completion(obj)
            } catch {
                fatalError("Failed to fetch employees: \(error)")
            }
        }
    }
    
    func saveImages(_ objects: [AnyObject]) -> [MPSImage] {
        var imagesArray: Array<MPSImage> = Array()
        
        for dictionary in objects {
            
            print(dictionary)
            
            let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "MPSImage", in: self.managedObjectContext)!
            let imageObj: MPSImage = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as! MPSImage
            
            let userObj = dictionary["user"] as? [String:AnyObject]
            imageObj.name = userObj?["name"] as? String
            imageObj.imageId = dictionary["id"] as? String
            imageObj.smallDescription = userObj?["bio"] as? String
            
            let urls = dictionary["urls"] as? [String:AnyObject]
            imageObj.downloadURLStr = urls?["regular"] as? String
            
            imagesArray.append(imageObj)
        }
        
        self.saveContext()        
        return imagesArray
    }
}
