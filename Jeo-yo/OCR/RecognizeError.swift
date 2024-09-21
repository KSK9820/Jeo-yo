//
//  RecognizeError.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation

enum RecognizeError: Error, CustomStringConvertible {
    case noImage
    case unknown(description: String)
    case noText
    
    var description: String {
        switch self {
        case .noImage:
            return "이미지가 없습니다."
        case .unknown(let description):
            return description
        case .noText:
            return "이미지에 인식할 수 있는 텍스트가 없습니다."
        }
    }
}
