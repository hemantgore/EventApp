//
//  EventCellBuilder.swift
//  EventApp
//
//  Created by Hemant Gore on 24/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation

struct EventCellBuilder {
    func makeTitleSubtitleCellViewModel(_ type: TitleSubtitleCellViewModel.CellType, onCellUpdate: (() -> Void)?) -> TitleSubtitleCellViewModel {
        switch type {
        case .text:
            return TitleSubtitleCellViewModel(title: "Name",
                                              subTitle: "", placeHolder: "Add a name",
                                              type: .text,
                                              onCellUpdate: onCellUpdate)
        case .date:
            return TitleSubtitleCellViewModel(title: "Date", subTitle: "", placeHolder: "Select a date", type: .date, onCellUpdate: onCellUpdate)
        case .image:
            return TitleSubtitleCellViewModel(title: "Background",
                                              subTitle: "",
                                              placeHolder: "Add a image", type: .image,
                                              onCellUpdate: onCellUpdate)
        }
    }
}
