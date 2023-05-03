//
//  String+Ext.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//
//  Resource for date formats: https://nsdateformatter.com
//

import Foundation

extension String {

    func convertToDate() -> Date? {

        let formatter           = DateFormatter()
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.timeZone      = .current

        return formatter.date(from: self)
    }
}
