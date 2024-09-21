//
//  NetworkError.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/16/24.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknownError(description: String)
    case responseError(statusCode: Int)
    case emptyDataError
    case notFoundAPIKey
    case notFoundBaseURL
    case decodingError
    
    var description: String {
        switch self {
        case .unknownError(let description):
            return "\(description)"
        case .responseError(let statusCode):
            return "Response Error: \(statusCode)"
        case .emptyDataError:
            return "서버에 해당 데이터가 존재하지 않아 데이터를 불러오지 못했습니다."
        case .notFoundAPIKey:
            return "APIKey가 존재하지 않습니다."
        case .notFoundBaseURL:
            return "BaseURL이 존재하지 않습니다."
        case .decodingError:
            return "Decoding에 실패하였습니다."
        }
    }
}
