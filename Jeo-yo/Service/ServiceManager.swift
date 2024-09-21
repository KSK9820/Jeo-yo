//
//  ServiceManager.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/22/24.
//

import Foundation
import Combine

final class ServiceManager {
    
    private let recognizer = ImageTextRecognizer()
    private var cancellables = Set<AnyCancellable>()
    
    func getRecruitmentInformation(from imageData: Data?) -> Future<Recruitment, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            self.recognizer.recognizeText(imageData)
                .sink { completion in
                    if case let.failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { text in
                    let message = Message.setMessage(text)
                    let request = JobOpeningRequest(messages: message)
                    
                    NetworkManager.shared.getRecruitment(request)
                        .sink { completion in
                            if case let.failure(error) = completion {
                                promise(.failure(error))
                            }
                        } receiveValue: { recruitment in
                            promise(.success(recruitment))
                        }
                        .store(in: &self.cancellables)
                }
                .store(in: &cancellables)
        }
    }
    
}
