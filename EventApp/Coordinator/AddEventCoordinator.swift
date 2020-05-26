//
//  AddEventCoordinator.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import UIKit

final class AddEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?

    var parentCoordinator: EventListCoordinator?

    private var completion: (UIImage) -> Void = {_ in }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.modalNavigationController = UINavigationController()

        let addEventVC: AddEventViewController = .instantiate()
        let viewModel = AddEventViewModel(cellBuilder: EventCellBuilder(), coreDataManager: CoreDataManager.shared)
        viewModel.coordinator = self
        addEventVC.viewModel = viewModel

        modalNavigationController?.setViewControllers([addEventVC], animated: false)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    func didFinishSaveEvent() {
        parentCoordinator?.onUpdateEvent()
        navigationController.dismiss(animated: true, completion: nil)
    }

    func showImagePicker(completion: @escaping (UIImage) -> Void) {
        guard  let modalNavigationController = modalNavigationController else {
            return
        }
        self.completion = completion

        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: modalNavigationController)
        imagePickerCoordinator.onFinishPicking = { image in
            self.completion(image)
            self.modalNavigationController?.dismiss(animated: true, completion: nil)
        }
        imagePickerCoordinator.parentCoordinator = self
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
