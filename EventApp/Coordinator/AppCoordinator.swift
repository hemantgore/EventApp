//
//  AppCoordinator.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func start()
}
final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow


    init(window: UIWindow) {
        self.window = window
    }
    func start() {
        let navigationController = UINavigationController()

        let eventListCoordinator = EventListCoordinator(navigationController: navigationController)

        eventListCoordinator.start()

        childCoordinators.append(eventListCoordinator)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
