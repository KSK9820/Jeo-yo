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
    @Published var errorPublisher = PassthroughSubject<String, Never>()
    
    init() {
        input.readImage
            .sink(receiveValue: { [weak self] data in
                guard let self else { return }
                
                self.serviceManager.getRecruitmentInformation(from: data)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            self.errorPublisher.send(error.localizedDescription)
                        }
                    } receiveValue: { recruitment in
                        self.recrutiment = recruitment
                        self.recrutiment?.image = data ?? Data()
                        self.showAlert = false
                    }
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
}
