//
//  JobOpeningRequest.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/20/24.
//

import Foundation

struct JobOpeningRequest: Encodable {
    let model = "gpt-3.5-turbo-1106"
    var messages: [Message]
}

struct Message: Codable {
    let role: String
    var content: String
    
    init(role: String = "system", content: String) {
        self.role = role
        self.content = content
    }
}
