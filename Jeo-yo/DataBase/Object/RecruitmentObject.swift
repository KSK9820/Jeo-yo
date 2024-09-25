//
//  RecruitmentObject.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/25/24.
//

import Foundation
import RealmSwift

final class RecruitmentObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var company: String
    @Persisted var applicationPeriods: ApplicationPeriodObject?
    @Persisted var steps = List<StepObject>()
    @Persisted var recruitmentImage: Data

    override init() {
        super.init()
        self.objectId = ObjectId.generate()
    }

    convenience init(company: String, applicationPeriods: ApplicationPeriodObject?, steps: List<StepObject> = List<StepObject>(), recruitmentImage: Data) {
        self.init()
        self.company = company
        self.applicationPeriods = applicationPeriods
        self.steps = steps
        self.recruitmentImage = recruitmentImage
    }
    
    func toDomain() -> Recruitment {
        let period = self.applicationPeriods?.toDomain() ?? ApplicationPeriodObject().toDomain()
        var step = [Step]()
        for s in self.steps {
            step.append(s.toDomain())
        }
        
        return Recruitment(company: self.company,
                    applicationPeriods: period,
                    steps: step,
                    image: self.recruitmentImage)
    }
}

