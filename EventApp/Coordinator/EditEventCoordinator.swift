//
//  EditEventCoordinator.swift
//  EventApp
//
//  Created by Hemant Gore on 26/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import UIKit

final class EditEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private let event: Event

    var parentCoordinator: EventDetailCoordinator?

    private var completion: (UIImage) -> Void = {_ in }

    init(event: Event,
         navigationController: UINavigationController) {
        self.event = event
        self.navigationController = navigationController
    }

    func start() {

        let editEventVC: EditEventViewController = .instantiate()
        let viewModel = EditEventViewModel(event: event, cellBuilder: EventCellBuilder(), coreDataManager: CoreDataManager.shared)
        viewModel.coordinator = self
        editEventVC.viewModel = viewModel
        navigationController.pushViewController(editEventVC, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    func didFinishUpdateEvent() {
        parentCoordinator?.onUpdateEvent()
        navigationController.popViewController(animated: true)
    }

    func showImagePicker(completion: @escaping (UIImage) -> Void) {
        self.completion = completion

        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: navigationController)
        imagePickerCoordinator.parentCoordinator = self
        imagePickerCoordinator.onFinishPicking = { image in
            completion(image)
            self.navigationController.dismiss(animated: true, completion: nil)
        }
        childCoordinators.append(imagePickerCoordinator)
        imagePickerCoordinator.start()

    }

    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }

    deinit {
        print("deinit called")
    }
}
