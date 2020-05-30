//
//  AddEventViewModel.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation

final class AddEventViewModel {
    var onUpdate: (() -> Void) = {}
    var title = "Add"
    weak var coordinator: AddEventCoordinator?

    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    private(set) var cells: [AddEventViewModel.Cell] = []

    private var nameCellVM: TitleSubtitleCellViewModel?
    private var dateCellVM: TitleSubtitleCellViewModel?
    private var backgroundCellVM: TitleSubtitleCellViewModel?
    private let cellBuilder: EventCellBuilder
    private let eventService: EventServiceProtocol

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()

    init(cellBuilder: EventCellBuilder, eventService: EventServiceProtocol = EventService()) {
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

        eventService.perform(.add, data: EventService.EventDataInputData(name: name, date: dateString, image: image))
        coordinator?.didFinishSaveEvent()
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

private extension AddEventViewModel {
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

    }
}
