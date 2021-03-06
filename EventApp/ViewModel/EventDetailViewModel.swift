//
//  EventDetailViewModel.swift
//  EventApp
//
//  Created by Hemant Gore on 26/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class EventDetailViewModel {
    private let eventID: NSManagedObjectID
    private let eventService: EventServiceProtocol
    private var event: Event?
    private let date = Date()
    var coordinator: EventDetailCoordinator?

    var onUpdate = {}

    var image: UIImage? {
        guard let imageData = event?.image, let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }

    var timeRemainingViewModel: TimeRemainingViewModel? {
        guard let eventDate = event?.date, let timeRemainingParts = date.timeRemaining(until: eventDate)?.components(separatedBy: ",") else {
            return nil
        }

        return TimeRemainingViewModel(timeRemainingParts: timeRemainingParts, mode: .detail)
    }

    init(eventID: NSManagedObjectID, eventService: EventServiceProtocol = EventService()) {
        self.eventID = eventID
        self.eventService = eventService
    }

    func viewDidLoad() {
        reload()
    }

    func viewDidDisappear() {
        coordinator?.didFinish()
    }

    func reload() {
        self.event = eventService.getEvent(eventID)
        onUpdate()
    }
    @objc
    func editButtonTapped() {
        guard let event = event else { return }
        coordinator?.onEditEvent(event)
        
    }
}
