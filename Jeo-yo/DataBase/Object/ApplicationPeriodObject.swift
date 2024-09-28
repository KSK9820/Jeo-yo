//
//  ApplicationPeriodObject.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/26/24.
//

import Foundation
import RealmSwift

final class ApplicationPeriodObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var resultDate: Date?
    @Persisted var isAlarm: Bool = true
    @Persisted var alarmInterval: List<Date> = List()

    override init() {
        super.init()
        self.objectId = ObjectId.generate()
    }

    convenience init(startDate: Date?, endDate: Date?, resultDate: Date?) {
        self.init()
        self.startDate = startDate
        self.endDate = endDate
        self.resultDate = resultDate
    }
    
    func toDomain() -> ApplicationPeriod {
        ApplicationPeriod(startDate: self.startDate, endDate: self.endDate)
    }
}
