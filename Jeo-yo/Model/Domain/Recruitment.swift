//
//  Recruitment.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/22/24.
//

import Foundation

struct Recruitment {
    let company: String
    let applicationPeriods: ApplicationPeriod?
    let steps: [Step]
    
    struct ApplicationPeriod {
        let startDate: Date?
        let endDate: Date?
    }
    
    struct Step {
        let name: String
        let description: String?
        let period: ApplicationPeriod?
    }
}
