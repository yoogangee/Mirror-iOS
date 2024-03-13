//
//  CustomError.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/13.
//

import Foundation

enum CustomError: Error {
    case badURL
    case noImageData
    case urlSessionError
    case responseError
    case responseCodeError(code: Int)
    case noResultError
    case decodingError(error: NSError)
    
    var description: String {
        switch self {
        case .badURL:
            return "badURLError: url 생성에 실패했습니다."
        case .noImageData:
            return "noImageData: 이미지 데이터 추출에 실패했습니다."
        case .urlSessionError:
            return "urlSessionError: url session 통신에 실패했습니다."
        case .responseError:
            return "responseError: url session 응답을 받지 못했습니다."
        case .responseCodeError(code: let code):
            return "responseCodeError code: \(code)"
        case .noResultError:
            return "noResultError: result가 없습니다."
        case .decodingError(error: let error):
            return "decodingError: 다음과 같은 이유로 디코딩에 실패했습니다.\n\(error)"
        }
    }
}
