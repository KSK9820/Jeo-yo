//
//  RecruitmentResponse.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation

struct RecruitmentResponse: Decodable {
    let company: String?
    let applicationPeriod: ApplicationPeriodResponse?
    let steps: [StepResponse]?
    
    struct ApplicationPeriodResponse: Decodable {
        let startDate: String?
        let endDate: String?
    }
    
    struct StepResponse: Decodable {
        let name: String?
        let description: String?
        let period: ApplicationPeriodResponse?
    }
}

extension RecruitmentResponse {
    func toDomainModel() -> Recruitment {
        return Recruitment(
            company: self.company ?? "",
            applicationPeriods: self.applicationPeriod?.toDomainModel(),
            steps: (self.steps ?? []).map { $0.toDomainModel() }
        )
    }
}

extension RecruitmentResponse.ApplicationPeriodResponse {
    func toDomainModel() -> Recruitment.ApplicationPeriod {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return Recruitment.ApplicationPeriod(
            startDate: dateFormatter.date(from: self.startDate ?? ""),
            endDate: dateFormatter.date(from: self.endDate ?? "")
        )
    }
}

extension RecruitmentResponse.StepResponse {
    func toDomainModel() -> Recruitment.Step {
        return Recruitment.Step(
            name: self.name ?? "",
            description: self.description,
            period: self.period?.toDomainModel()
        )
    }
}
