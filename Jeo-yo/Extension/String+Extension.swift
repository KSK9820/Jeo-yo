//
//  String+Extension.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/25/24.
//

import Foundation

extension String {
    func convertDate(_ from: StringDateFormat, to: StringDateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from.rawValue
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        dateFormatter.dateFormat = to.rawValue
        return dateFormatter.string(from: date)
    }
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else { return nil }
        return date
    }

}
