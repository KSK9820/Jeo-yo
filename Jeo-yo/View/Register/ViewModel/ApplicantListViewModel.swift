//
//  ApplicantListViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/26/24.
//

import Foundation
import Combine

final class ApplicantListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    struct Input {
       
    }
    
    init() {
        RealmJobRepository.shared.readRecruitment()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] value in
                guard let self else { return }
                
                self.recruitment = value
            }
            .store(in: &cancellables)
    }
    
    @Published var recruitment: [Recruitment]?
    
}
