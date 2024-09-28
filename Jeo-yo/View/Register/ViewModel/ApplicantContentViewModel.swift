//
//  ApplicantContentViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import Foundation

final class ApplicantContentViewModel: ObservableObject {
    @Published var content: Recruitment
    private(set) var currentStep: (step: Step, index: Int)?
    var totalStepsCount: Int {
        content.steps.count
    }

     init(_ content: Recruitment) {
        self.content = content
        
        currentStep = content.getCurrentStep()
    }
 
    func getRecruitmentStatus() -> (Step, Int)? {
        switch content.getCurrentPeriodStatus() {
        case .inProgress:
            return content.getCurrentStep()
        case .immediate:
            return (Step(name: ProgressStatus.immediate.name, description: "", period: ApplicationPeriod()), ProgressStatus.immediate.rawValue)
        case .expected:
            return (Step(name: ProgressStatus.expected.name, description: "", period: ApplicationPeriod()), ProgressStatus.expected.rawValue)
        case .finished:
            return (Step(name: ProgressStatus.finished.name, description: "", period: ApplicationPeriod()), ProgressStatus.finished.rawValue)
        }
    }
}
