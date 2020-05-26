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

    init(eventID: NSManagedObjectID, navigationController: UINavigationController) {
        self.eventID = eventID
        self.navigationController = navigationController
    }

    func start() {
        let eventDetailViewController: EventDetailViewController = .instantiate()

        let viewModel = EventDetailViewModel(eventID: eventID)
        viewModel.coordinator = self
        eventDetailViewController.viewModel = viewModel

        navigationController.pushViewController(eventDetailViewController, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    deinit {
        print("event Detail Coordinator deinit")
    }
}
