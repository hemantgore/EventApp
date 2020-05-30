//
//  EventListCoordinator.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class EventListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    var onUpdateEvent = {}
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let eventListVC : EventListViewController = .instantiate()
        let eventListVM = EventListViewModel()
        eventListVM.coordinator = self
        onUpdateEvent = eventListVM.reload
        eventListVC.viewModel = eventListVM

        navigationController.setViewControllers([eventListVC], animated: false)
    }

    func startAddEvent() {
        let addEventCoordinator = AddEventCoordinator(navigationController: navigationController)
        addEventCoordinator.parentCoordinator = self
        childCoordinators.append(addEventCoordinator)
        addEventCoordinator.start()
    }

    func onSelect(_ id: NSManagedObjectID) {
        let eventDetailsCoordinator = EventDetailCoordinator(eventID: id, navigationController: navigationController)

        eventDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(eventDetailsCoordinator)
        eventDetailsCoordinator.start()

    }

    func childDidFinish(_ childCoordinator: Coordinator) {

        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
