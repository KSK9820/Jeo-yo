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
            당신은 채용 공고를 분석하는 역할을 맡았습니다. 회사명, 모집 기간 그리고 채용 공고의 전형별 절차를 분류헤야합니다. 공고의 전형별 절차엔느 보통 구분(이름), 내용, 일정들이 있습니다. 일정에는 기간과 합격일이 있을 경우에는 기간만 분류하면 됩니다. 날짜는 yyyy의 형태로 맞추어야합니다, 가급적 공고에 있는 내용만을 사용해야합니다. 사족을 붙이지 말고 아래의 struct 타입에 맞춘 JSON으로 응답을 보내야합니다.
            
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
