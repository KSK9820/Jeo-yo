//
//  ProgressStatus.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import Foundation

enum ProgressStatus: Int {
    case immediate = -1
    case expected = -2
    case finished = -3
    case inProgress = 0
}

extension ProgressStatus {
    var name: String {
        switch self {
        case .immediate:
            "상시 채용"
        case .expected:
            "모집 전"
        case .finished:
            "모집 완료"
        case .inProgress:
            "진행 중"
        }
    }
    
    
}
