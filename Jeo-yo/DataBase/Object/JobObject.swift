//
//  JobObject.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/26/24.
//

import Foundation
import RealmSwift

final class JobObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var job: String
    @Persisted var recruitment = List<RecruitmentObject>()

    override init() {
        super.init()
        self.objectId = ObjectId.generate()
    }

    convenience init(job: String, recruitment: List<RecruitmentObject> = List<RecruitmentObject>()) {
        self.init()
        self.job = job
        self.recruitment = recruitment
    }
}
