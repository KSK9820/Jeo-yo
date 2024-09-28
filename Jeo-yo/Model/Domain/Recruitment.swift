//
//  Recruitment.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/22/24.
//

import Foundation
import RealmSwift

struct Recruitment: Identifiable, Equatable {
    static func == (lhs: Recruitment, rhs: Recruitment) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var company: String
    var applicationPeriods: ApplicationPeriod
    var steps: [Step]
    var image: Data
    
    func toRecruitmentTable() -> RecruitmentObject {
        let applicationPeriodData = self.applicationPeriods.toApplicationPeriodTable()
        let stepTableData = List<StepObject>()
        
        for step in self.steps {
            stepTableData.append(step.toStepTable())
        }
        
        return RecruitmentObject(company: self.company,
                         applicationPeriods: applicationPeriodData,
                         steps: stepTableData,
                         recruitmentImage: self.image)
    }
    
    func getCurrentPeriodStatus() -> ProgressStatus {
        let today = Date()
        if self.applicationPeriods.startDate == nil && self.applicationPeriods.endDate == nil {
            return .immediate
        }
        
        if let start = self.applicationPeriods.startDate, start < today {
            return .expected
        }
        
        if let end = self.applicationPeriods.endDate, end > today {
            return .finished
        }
        
        return .inProgress
    }
    
    func getCurrentStep() -> (Step, Int)? {
        let today = Date()
        
        for step in self.steps.indices {
            if let startDate = steps[step].period.startDate,
               let endDate = steps[step].period.endDate {
                if startDate <= today && today >= endDate {
                    return (steps[step], step)
                }
            }
        }
        return nil
    }
}


struct ApplicationPeriod {
    var startDate: Date?
    var endDate: Date?
    
    func toApplicationPeriodTable() -> ApplicationPeriodObject {
        return ApplicationPeriodObject(startDate: self.startDate, endDate: self.endDate, resultDate: nil)
    }
}

struct Step: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var period: ApplicationPeriod
    
    func toStepTable() -> StepObject {
        StepObject(name: self.name,
                  descriptionText: self.description,
                  period: self.period.toApplicationPeriodTable())
    }
    
}
