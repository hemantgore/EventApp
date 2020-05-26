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

    func saveEvent(name: String, date: Date, image: UIImage) {
        let event = Event(context: moc)
        event.setValue(name, forKey: "name")

        let resizedImage = image.sameAspectRation(newHeight: 250)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        event.setValue(date, forKey: "date")

        do {
            try moc.save()
        } catch {
            print(error)
        }
    }

    func fetchEvents() -> [Event] {
        do {
            let fetchReq = NSFetchRequest<Event>(entityName: "Event")
            let events = try moc.fetch(fetchReq)
            return events
        } catch {
            print(error)
            return []
        }
    }

    func getEvent(_ id: NSManagedObjectID) -> Event? {
        do {
            return try moc.existingObject(with: id) as? Event
        } catch {
            print(error)
        }
        return nil
    }
}
