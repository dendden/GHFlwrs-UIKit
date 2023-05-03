//
//  Date+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import Foundation

extension Date {

    var shortMonthAndYear: String {

        self.formatted(
            .dateTime
                .month()
                .year()
        )
    }

    func convertToShortMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"

        return formatter.string(from: self)
    }
}
