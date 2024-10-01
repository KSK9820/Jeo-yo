//
//  Tab.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import Foundation

enum Tab {
    case main
    case calendar
    case register
}

extension Tab {
    var title: String {
        switch self {
        case .main:
            "저요!"
        case .calendar:
            "캘린더"
        case .register:
            "등록"
        }
    }
    
    var image: String {
        switch self {
        case .main:
            "hand.raised.fingers.spread"
        case .calendar:
            "calendar"
        case .register:
            "list.star"
        }
    }
}
