//
//  RecruitmentResponse.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation

struct RecruitmentResponse: Decodable {
    let company: String?
    let applicationPeriod: [ApplicationPeriodResponse]
    let steps: [StepResponse]
    
    struct ApplicationPeriodResponse: Decodable {
        let startDate: String?
        let endDate: String?
    }
    
    struct StepResponse: Decodable {
        let name: String?
        let description: String?
        let period: [ApplicationPeriodResponse]?
    }
}
