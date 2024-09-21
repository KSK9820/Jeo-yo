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
    
    static func setMessage(_ message: String) -> [Message] {
        let order = message + """
              채용 공고를 분석해서 아래의 JSON 형태로 알려줘. 채용 설명회 말고 주로 채용 공고에서 나오는 절차들로 분류해줘, Swift에서 사용할거야. 사족을 붙이지 말고 JSON 형태로만 응답을 보내줘.
              struct Recruitment: Decodable {
                  let company: String?
                  let applicationPeriod: [ApplicationPeriod]
                  let steps: [Step]
                  
                  struct ApplicationPeriod: Decodable {
                      let startDate: String?
                      let endDate: String?
                  }
                  
                  struct Step: Decodable {
                      let name: String?
                      let description: String?
                      let period: [ApplicationPeriod]?
                  }
              }
            """
        return [Message(content: order)]
    }
}
