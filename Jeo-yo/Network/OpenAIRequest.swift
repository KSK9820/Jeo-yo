//
//  OpenAIRequest.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/20/24.
//

import Foundation
import Moya

enum OpenAIRequest {
    case jobOpening(recruitment: JobOpeningRequest)
}

extension OpenAIRequest: TargetType {
    var baseURL: URL {
        guard let baseURLString = Bundle.main.infoDictionary?["BaseURL"] as? String,
              let baseURL = URL(string: baseURLString) else {
            print("BaseURL is missing or invalid in the Info.plist")
            return URL(string: "")!
        }
        
        return baseURL
    }
 
    var path: String {
        switch self {
        case .jobOpening:
            ["v1", "chat", "completions"].joined(separator: "/")
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .jobOpening:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .jobOpening(let recruitment):
            return .requestJSONEncodable(recruitment)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .jobOpening:
            guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else { return nil }
            
            return [
                HeaderContents.authorization.rawValue : "Bearer \(apiKey)",
                HeaderContents.contentType.rawValue : HeaderContents.json.rawValue
            ]
        }
    }
    
}
