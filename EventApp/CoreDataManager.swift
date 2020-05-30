//
//  CoreDataManager.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "EventApp")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ??
            "")
        }
        return persistentContainer
    }()

    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func save() {
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }

    func get<T: NSManagedObject>(_ id: NSManagedObjectID) -> T? {
        do {
            return try moc.existingObject(with: id) as? T
        } catch {
            print(error)
        }
        return nil
    }

    func getAll<T: NSManagedObject>() -> [T] {
        do {
            let fetchReq = NSFetchRequest<T>(entityName: "\(T.self)")
            return try moc.fetch(fetchReq)
        } catch {
            print(error)
            return []
        }
    }

}
