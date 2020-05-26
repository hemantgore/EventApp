//
//  Date+Extension.swift
//  EventApp
//
//  Created by Hemant Gore on 25/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import Foundation

extension Date {
    func timeRemaining(until endDate: Date) -> String? {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
        dateComponentFormatter.unitsStyle = .full
        return dateComponentFormatter.string(from: self, to: endDate)
    }
}
