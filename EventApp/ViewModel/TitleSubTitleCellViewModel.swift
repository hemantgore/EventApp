//
//  TitleSubTitleCellViewModel.swift
//  EventApp
//
//  Created by Hemant Gore on 23/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation
import UIKit

final class TitleSubtitleCellViewModel {

    enum CellType {
        case text
        case date
        case image
    }

    let type: CellType

    let title: String
    private(set) var subTitle: String
    let placeHolder: String

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()

    private(set) var onCellUpdate: (() -> Void)?

    private(set) var image: UIImage?

    init(title: String, subTitle: String, placeHolder: String, type: CellType, onCellUpdate: (() -> Void)?) {
        self.title = title
        self.subTitle = subTitle
        self.placeHolder = placeHolder
        self.type = type
        self.onCellUpdate = onCellUpdate

    }

    func update(_ subtitle: String) {
        subTitle = subtitle
    }

    func update(_ date: Date) {
        let dateString = dateFormatter.string(from: date)
        self.subTitle = dateString
        onCellUpdate?()
    }

    func update(_ image: UIImage) {
        self.image = image
        onCellUpdate?()
    }
}
