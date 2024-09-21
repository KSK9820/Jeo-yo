//
//  NetworkManager.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let provider = MoyaProvider<OpenAIRequest>()
    
    private init() {}
    
    func getRecruitment(_ data: JobOpeningRequest) -> AnyPublisher<RecruitmentResponse, Error> {
        getData(.jobOpening(recruitment: data), response: JobOpeningResponse.self)
            .mapError { NetworkError.unknownError(description: $0.localizedDescription) }
            .flatMap { response -> AnyPublisher<RecruitmentResponse, Error> in
                guard let content = response.choices.first?.message.content else {
                    return Fail(error: NetworkError.emptyDataError).eraseToAnyPublisher()
                }
                
                guard let jsonData = content.data(using: .utf8) else {
                    return Fail(error: NetworkError.decodingError).eraseToAnyPublisher()
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(RecruitmentResponse.self, from: jsonData)
                    return Just(decodedData)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: NetworkError.decodingError).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func getData<D: Decodable>(_ request: OpenAIRequest, response: D.Type) -> AnyPublisher<D, Error> {
        provider.requestPublisher(request)
            .tryMap { response in
                try response.map(D.self)
            }
            .eraseToAnyPublisher()
    }
    
}
