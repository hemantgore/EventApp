//
//  EditEventViewModel.swift
//  EventApp
//
//  Created by Hemant Gore on 26/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import UIKit

final class EditEventViewModel {
    var onUpdate: (() -> Void) = {}
    var title = "Edit"
    weak var coordinator: EditEventCoordinator?

    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    private(set) var cells: [EditEventViewModel.Cell] = []

    private var nameCellVM: TitleSubtitleCellViewModel?
    private var dateCellVM: TitleSubtitleCellViewModel?
    private var backgroundCellVM: TitleSubtitleCellViewModel?
    private let cellBuilder: EventCellBuilder
    private let eventService: EventServiceProtocol
    private let event: Event

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()

    init(event: Event,
         cellBuilder: EventCellBuilder,
         eventService: EventServiceProtocol = EventService()) {
        self.event = event
        self.cellBuilder = cellBuilder
        self.eventService = eventService
    }

    func viewDidLoad() {
        setupCell()
        onUpdate()
    }

    func viewDidDisappear() {
        coordinator?.didFinish()
    }

    func numberOfRows() -> Int {
       cells.count
    }

    func cell(for indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }

    func tappedDone() {
        guard let name = nameCellVM?.subTitle,
            let date = dateCellVM?.subTitle,
            let image = backgroundCellVM?.image,
            let dateString = dateFormatter.date(from: date) else {
            return
        }

        eventService.perform(.update(event), data: EventService.EventDataInputData(name: name, date: dateString, image: image))
//        updateEvent(event: event, name: name, date: dateString, image: image)
        coordinator?.didFinishUpdateEvent()
    }

    func update(indexPath: IndexPath, subtitle: String) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellVM):
            titleSubtitleCellVM.update(subtitle)
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellVM):
            guard titleSubtitleCellVM.type == .image else {
                return
            }

            coordinator?.showImagePicker { image in
                titleSubtitleCellVM.update(image)
            }
        }
    }

    deinit {
        print("add event VM coordinator deinit")
    }
}

private extension EditEventViewModel {
    func setupCell() {
        nameCellVM = cellBuilder.makeTitleSubtitleCellViewModel(.text, onCellUpdate: nil)

        dateCellVM = cellBuilder.makeTitleSubtitleCellViewModel(.date) { [weak self] in
            self?.onUpdate()

        }

        backgroundCellVM = cellBuilder.makeTitleSubtitleCellViewModel(.image) { [weak self] in
            self?.onUpdate()
        }

        guard let nameCellVM = nameCellVM,
            let dateCellVM = dateCellVM,
            let backgroundCellVM = backgroundCellVM else {
                return
        }

        cells = [.titleSubtitle(nameCellVM), .titleSubtitle(dateCellVM), .titleSubtitle(backgroundCellVM)
        ]

        guard let name = event.name,
            let date = event.date,
            let imageData = event.image,
            let image = UIImage(data: imageData) else { return }
        nameCellVM.update(name)
        dateCellVM.update(date)
        backgroundCellVM.update(image)
    }
}



