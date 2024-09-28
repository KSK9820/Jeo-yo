//
//  Date+Extension.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/25/24.
//

import Foundation

extension Date {
    func toString(format: StringDateFormat, locale: Locale = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }
}
