//
//  EventService.swift
//  EventApp
//
//  Created by Hemant Gore on 30/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import UIKit
import CoreData

protocol EventServiceProtocol {
    func perform(_ action: EventService.EventAction, data: EventService.EventDataInputData)
    func getEvent(_ id: NSManagedObjectID) -> Event?
    func getEvents() -> [Event]
}

final class EventService: EventServiceProtocol {

    struct EventDataInputData {
        let name: String
        let date: Date
        let image: UIImage
    }

    enum EventAction {
        case add
        case update(Event)
    }

    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    func perform(_ action: EventAction, data: EventDataInputData) {
        var event: Event
        switch action {
        case .add:
            event = Event(context: coreDataManager.moc)
        case .update(let eventToUpdate):
            event = eventToUpdate
        }
        event.setValue(data.name, forKey: "name")

        let resizedImage = data.image.sameAspectRation(newHeight: 250)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        event.setValue(data.date, forKey: "date")

        coreDataManager.save()
    }

    func getEvent(_ id: NSManagedObjectID) -> Event? {
        return coreDataManager.get(id)
    }

    func getEvents() -> [Event] {
        return coreDataManager.getAll()
    }
}
