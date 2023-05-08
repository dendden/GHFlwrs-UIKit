//
//  Date+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import Foundation

extension Date {

    /// Formatted presentation of `Date`: e.g. **Jan 2018**.
    var shortMonthAndYear: String {

        self.formatted(
            .dateTime
                .month()
                .year()
        )
    }

    /// Converts `Date` into a string presentation using custom
    /// `DateFormatter`.
    /// - Returns: A `String` presentation of date, e.g. **Jan 2018**.
    func convertToShortMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"

        return formatter.string(from: self)
    }
}
