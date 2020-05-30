//
//  EventListViewModel.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation

final class EventListViewModel {
    var title = "Event"
    var coordinator: EventListCoordinator?
    var onUpdate: (() -> Void)?
    enum Cell {
        case event(EventCellViewModel)
    }

    private var eventService: EventServiceProtocol
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
    private(set) var cells: [Cell] = []

    func viewDidLoad() {
        reload()
    }

    func reload() {
        EventCellViewModel.imageCache.removeAllObjects()
        let events = eventService.getEvents()

        cells = events.map {
            var eventCellViewModel = EventCellViewModel($0)
            if let coordinator = coordinator {
                eventCellViewModel.onSelect = coordinator.onSelect
            }
            return .event(eventCellViewModel)
        }

        onUpdate?()
    }

    func tappedAddEvent() {
        // coordinator to start
        coordinator?.startAddEvent()
    }

    func numberRows() -> Int {
        return cells.count
    }

    func cell(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .event(let eventCellViewModel):
            eventCellViewModel.didSelect()
        }
    }
}
