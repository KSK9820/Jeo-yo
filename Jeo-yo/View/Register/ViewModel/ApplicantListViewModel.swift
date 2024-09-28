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
        let updateData = PassthroughSubject<Void, Never>()
        let searchText = PassthroughSubject<String, Never>()
        let resetText = PassthroughSubject<Void, Never>()
    }
    
    @Published var recruitment: [Recruitment]?
    @Published var searchRecruitment: [Recruitment] = []
    
    init() {
        input.updateData.sink { _ in
            RealmJobRepository.shared.readRecruitment()
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    self.recruitment = value
                    self.searchRecruitment = value
                }
                .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
        
        input.searchText
            .sink { [weak self] text in
                guard let self else { return }

                if let recruitment {
                    self.searchRecruitment = recruitment.filter { $0.company.lowercased().contains(text.lowercased()) }
                } else {
                    self.searchRecruitment = []
                }
            }
            .store(in: &cancellables)
        
        input.resetText
            .sink { [weak self] _ in
                guard let self else { return }
                if let recruitment {
                    self.searchRecruitment = recruitment
                } else {
                    self.searchRecruitment = []
                }
            }
            .store(in: &cancellables)
    }
    
}
