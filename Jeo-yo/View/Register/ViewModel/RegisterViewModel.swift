//
//  RegisterViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    private let serviceManager = ServiceManager()

    private var cancellables = Set<AnyCancellable>()

    var input = Input()
    
    struct Input {
        let readImage = PassthroughSubject<Data?, Never>()
    }
    
    // Output
    @Published var recrutiment: Recruitment?
    @Published var showAlert = true
    
    init() {
        input.readImage
            .sink { completion in
                
            } receiveValue: { [weak self] data in
                guard let self else { return }
                
                self.serviceManager.getRecruitmentInformation(from: data)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            print(error)
                        case .finished:
                            print("success")
                        }
                    } receiveValue: { recruitment in
                        print(recruitment)
                        self.recrutiment = recruitment
                        self.showAlert = false
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)

    }
    
}
