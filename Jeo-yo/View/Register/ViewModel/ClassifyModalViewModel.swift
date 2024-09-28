//
//  ClassifyModalViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/24/24.
//

import Combine
import RealmSwift

final class ClassifyModalViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    struct Input {
        let recruitment = PassthroughSubject<Recruitment, Error>()
        let addStepButtonTapped = PassthroughSubject<Void, Never>()
        let saveButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    @Published var recruitment: Recruitment
    
    init(recruitment: Recruitment) {
        self.recruitment = recruitment
        
        input.recruitment
            .sink { completion in
                if case let.failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] recruitment in
                guard let self else { return }
                
                self.recruitment = recruitment
            }
            .store(in: &cancellables)
        
        input.addStepButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.recruitment.steps.append(Step(name: "", description: "", period: ApplicationPeriod()))
            }
            .store(in: &cancellables)
        
        input.saveButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }

                RealmJobRepository.shared.addRecruitment(data: self.recruitment)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            print(error)
                        }
                    } receiveValue: { }
                    .store(in: &cancellables)

            }
            .store(in: &cancellables)
    }
    
    func validatePeriod() -> Bool {
        if let start = recruitment.applicationPeriods.startDate,
           let end = recruitment.applicationPeriods.endDate {
            if start > end { return false }
        } else { return true }
        
        for step in recruitment.steps {
            if let start = step.period.startDate,
               let end = step.period.endDate {
                if start > end { return false }
            }
        }
        
        return true
    }
    
}
