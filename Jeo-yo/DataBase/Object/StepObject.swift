//
//  StepObject.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/26/24.
//

import Foundation
import RealmSwift

final class StepObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var name: String
    @Persisted var descriptionText: String
    @Persisted var period: ApplicationPeriodObject?
    @Persisted var isAlarm: Bool = false

    override init() {
        super.init()
        self.objectId = ObjectId.generate()
    }

    convenience init(name: String, descriptionText: String, period: ApplicationPeriodObject?) {
        self.init()
        self.name = name
        self.descriptionText = descriptionText
        self.period = period
    }
    
    func toDomain() -> Step {
        Step(name: self.name, description: self.description, period: self.period?.toDomain() ?? ApplicationPeriodObject().toDomain())
    }
}

