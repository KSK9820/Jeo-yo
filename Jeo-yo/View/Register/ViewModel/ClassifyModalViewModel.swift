//
//  ClassifyModalViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/24/24.
//

import SwiftUI
import Combine

final class ClassifyModalViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    struct Input {
        let recruitment = PassthroughSubject<Recruitment, Error>()
        let addStepButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    init(recruitment: Recruitment) {
        self.recruitment = recruitment
        
        input.recruitment
            .sink { completion in
                if case let.failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] recruitment in
                // 화면에 표시할 데이터로의 가공
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
    }
    
    @Published var recruitment: Recruitment
    
}
