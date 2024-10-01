//
//  RealmJobRepository.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/26/24.
//

import Foundation
import Combine
import RealmSwift

class RealmJobRepository {
    
    static let shared = RealmJobRepository()
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
        print(realm.configuration.fileURL)
    }
    
    func addRecruitment(data: Recruitment) -> Future<Void, Error> {
        let convertedData = data.toRecruitmentTable()
        
        return Future { [weak self] promise in
            guard let self else { return }
            
            do {
                if let existingJob = realm.objects(JobObject.self).first {
                    try realm.write {
                        existingJob.recruitment.append(convertedData)
                    }
                    
                    promise(.success(()))
                } else {
                    let newJob = JobObject(job: "직무1", recruitment: List<RecruitmentObject>())
                    newJob.recruitment.append(convertedData)
                    
                    try realm.write {
                        self.realm.add(newJob)
                    }
                    
                    promise(.success(()))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func readRecruitment() -> AnyPublisher<[Recruitment], Error> {
        return Future { [weak self] promise in
            guard let self else { return promise(.failure(JobError.initialize)) }
            
            let jobs = realm.objects(JobObject.self)
            if let recruitmentList = jobs.first {
                let convertedData = recruitmentList.recruitment.map { $0.toDomain() }
                promise(.success(Array(convertedData)))
            } else {
                promise(.success(Array([])))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func readMonthlyRecruitment(_ month: Date) -> AnyPublisher<[Recruitment], Error> {
        return Future { [weak self] promise in
            guard let self else { return promise(.failure(JobError.initialize)) }
            guard let monthRange = getMonthRange(for: month) else { return promise(.failure(JobError.input)) }
            guard let job = realm.objects(JobObject.self).first else { return promise(.failure(JobError.jobTable)) }
            
            let monthlyList = job.recruitment.filter { recruitment in
                if let startDate = recruitment.applicationPeriods?.startDate,
                   let endDate = recruitment.applicationPeriods?.endDate {
                    
                    return (startDate <= monthRange.endOfMonth && endDate >= monthRange.startOfMonth)
                }
                return false
            }

            let convertedData = monthlyList.map { $0.toDomain() }
            promise(.success(Array(convertedData)))
        }
        .eraseToAnyPublisher()
    }
    
    private func getMonthRange(for date: Date) -> (startOfMonth: Date, endOfMonth: Date)? {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            return nil
        }
        return (startOfMonth, endOfMonth.addingTimeInterval(-1))
    }
}

extension RealmJobRepository {
    private enum JobError: String, Error {
        case initialize = "Failed to initialize Realm"
        case input = "Wrong Input"
        case jobTable = "Job Table does not exist"
    }
}
