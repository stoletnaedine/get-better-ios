//
//  CoreDataManager.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 14.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class CoreDataManager {
    
    let coreDataName = "HelpApp"
    static let instance = CoreDataManager()
    private init() {}
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: coreDataName, withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing NSManagedObjectModel from: \(modelURL)")
        }
        return managedObjectModel
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        let storeURL = docURL.appendingPathComponent("\(coreDataName).sqlite")
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            
        }
        return persistentStoreCoordinator
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: coreDataName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = self.persistentContainer.viewContext
        return managedObjectContext
    }()
    
    func saveContext() {
        if self.managedObjectContext.hasChanges {
            managedObjectContext.perform {
                do {
                    try self.managedObjectContext.save()
                } catch {
                    fatalError("Error while trying to save context: \(error)")
                }
            }
        }
    }
    
    func deleteAllData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            for object in results {
                guard let managedObject = object as? NSManagedObject else { return }
                managedObjectContext.delete(managedObject)
            }
            print("\(entityName) is delete from CoreData!")
        } catch {
            fatalError("Error while try to delete entity data with name: \(entityName)")
        }
    }
    
    func save<T: PlainConvertable, D: CoreDataConvertable>(objects: [T], coreDataType: D.Type) {
        if !objects.isEmpty {
            CoreDataManager.instance.deleteAllData(entityName: String(describing: coreDataType.self))
            _ = objects.map {
                $0.convertToCoreData()
            }
            CoreDataManager.instance.saveContext()
        }
    }
    
    func fetchRequest<T: CoreDataConvertable>(entityName: String, coreDataType: T.Type, completion: @escaping ([T]) -> ()){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        self.managedObjectContext.perform {
            do {
                let objects = try self.managedObjectContext.fetch(fetchRequest) as! [T]
                completion(objects)
            } catch {
                fatalError()
            }
        }
    }
}
