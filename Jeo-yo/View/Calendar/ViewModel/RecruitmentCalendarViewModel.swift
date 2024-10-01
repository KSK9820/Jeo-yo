//
//  RecruitmentCalendarViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import SwiftUI
import Combine

final class RecruitmentCalendarViewModel: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    var input = Input()
    
    struct Input {
        let selectedMonth = PassthroughSubject<Date, Never>()
        let selectedDate = CurrentValueSubject<Date, Never>(Date())
    }
    
    @Published var monthlyRecruitment: [Recruitment] = []
    @Published var selectedDateRecruitment: [Recruitment] = []
    
    init() {
        input.selectedMonth
            .sink { [weak self] date in
                guard let self else { return }
                RealmJobRepository.shared.readMonthlyRecruitment(date)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            print(error)
                        }
                    } receiveValue: { list in
                        self.monthlyRecruitment = list
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        input.selectedDate
            .sink { [weak self] date in
                guard let self else { return }
                
                let recruitmentList = self.monthlyRecruitment.filter { recruitment in
                    if let startDate = recruitment.applicationPeriods.startDate,
                       let endDate = recruitment.applicationPeriods.endDate {
                        
                        return (startDate <= date && endDate >= date)
                    }
                    return false
                }

                self.selectedDateRecruitment = recruitmentList
            }
            .store(in: &cancellables)
    }

}
