//
//  JobOpeningResponse.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation

struct JobOpeningResponse: Decodable {
    let id: String
    let created: Int
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }
}
