//
//  EventCellViewModel.swift
//  EventApp
//
//  Created by Hemant Gore on 24/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import UIKit
import CoreData

struct EventCellViewModel {
    let date = Date()
    static let imageCache = NSCache<NSString, UIImage>()
    private var cacheKey: String {
        event.objectID.description
    }
    private let imageQueue = DispatchQueue(label: "imageQueue", qos: .background)
    var onSelect: (NSManagedObjectID) -> Void = { _ in }


    var timeRemainingString: [String] {
        guard let eventDate = event.date else {
            return []
        }
        return date.timeRemaining(until: eventDate)?.components(separatedBy: ",") ?? []
    }

    var dateText: String? {
        guard let eventDate = event.date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: eventDate)
    }

    var eventName: String? {
        event.name
    }

    var timeRemainingViewModel: TimeRemainingViewModel? {
        guard let eventDate = event.date, let timeRemainingParts = date.timeRemaining(until: eventDate)?.components(separatedBy: ",") else {
            return nil
        }

        return TimeRemainingViewModel(timeRemainingParts: timeRemainingParts, mode: .cell)

    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        // check cache 1st
        if let image = Self.imageCache.object(forKey: cacheKey as NSString) {
            completion(image)
        } else {
            imageQueue.async {
                guard let imageData = self.event.image, let image = UIImage(data: imageData) else {
                    completion(nil)
                    return
                }
                Self.imageCache.setObject(image, forKey: self.cacheKey as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }

            }

        }
    }

    func didSelect() {
        onSelect(event.objectID)
    }

    private let event: Event

    init(_ event: Event) {
        self.event = event
    }

}
