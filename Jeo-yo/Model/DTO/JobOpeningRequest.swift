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
            당신은 채용 공고를 분석하는 역할을 맡았습니다. 회사명, 모집 기간, 채용 설명회는 제외하고 주로 채용 공고에서 나오는 절차들로 분류헤야합니다. 가급적이면 공고에 있는 내용만을 사용해야합니다. Swift에서 사용할 것이며, 사족을 붙이지 말고 아래의 struct 타입에 맞춘 JSON으로 응답을 보내야합니다.
            
              struct RecruitmentResponse: Decodable {
                  let company: String?
                  let applicationPeriod: ApplicationPeriodResponse?
                  let steps: [StepResponse]?
                  
                  struct ApplicationPeriodResponse: Decodable {
                      let startDate: String?
                      let endDate: String?
                  }
                  
                  struct StepResponse: Decodable {
                      let name: String?
                      let description: String?
                      let period: ApplicationPeriodResponse?
                  }
              }
            """
        return [Message(content: order)]
    }
}
