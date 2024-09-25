//
//  Recruitment.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/22/24.
//

import Foundation

struct Recruitment: Identifiable {
    var id = UUID()
    var company: String
    var applicationPeriods: ApplicationPeriod
    var steps: [Step]
}

struct ApplicationPeriod {
    var startDate: Date?
    var endDate: Date?
}

struct Step: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var period: ApplicationPeriod
}
