//
//  EventDetailCoordinator.swift
//  EventApp
//
//  Created by Hemant Gore on 26/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import UIKit
import CoreData
final class EventDetailCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let eventID: NSManagedObjectID
    var parentCoordinator: EventListCoordinator?
    var onUpdateEvent = {}

    init(eventID: NSManagedObjectID, navigationController: UINavigationController) {
        self.eventID = eventID
        self.navigationController = navigationController
    }

    func start() {
        let eventDetailViewController: EventDetailViewController = .instantiate()

        let viewModel = EventDetailViewModel(eventID: eventID)
        viewModel.coordinator = self
        eventDetailViewController.viewModel = viewModel
        onUpdateEvent = {
            viewModel.reload()
            self.parentCoordinator?.onUpdateEvent()

        }
        navigationController.pushViewController(eventDetailViewController, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    func onEditEvent(_ event: Event) {
        let editEventCoordinator = EditEventCoordinator(event: event, navigationController: navigationController)
        editEventCoordinator.parentCoordinator = self
        childCoordinators.append(editEventCoordinator)
        editEventCoordinator.start()
    }

    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    deinit {
        print("event Detail Coordinator deinit")
    }
}
