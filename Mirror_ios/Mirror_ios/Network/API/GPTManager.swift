//
//  GPTManager.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/14.
//

import Foundation
import OpenAI
import UIKit

class GPTManager {
    
    static let shared = GPTManager()
    private init() {}
    
    let openAIKey = "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"
    
    func getAIResponse(_ message: String, completion: @escaping (Result<String, CustomError>) -> (Void)) {
        let openAI = OpenAI(apiToken: openAIKey)
        
        let query = ChatQuery(messages: [.init(role: .user, content: "\(message)\n위의 글을 간단하게 요약해줘.")!], model: .gpt3_5Turbo)
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let result):
        
                guard let responseString = result.choices[0].message.content?.string else {
                    SharedData.shared.summaryText = "요약된 내용이 없습니다."
                    completion(.failure(CustomError.noResultError))
                    return
                }
                print("GPT가 요약해준 내용: \(responseString)")
                
                if responseString == "" {
                    SharedData.shared.summaryText = "요약된 내용이 없습니다."
                    completion(.failure(CustomError.noResultError))
                } else {
                    SharedData.shared.summaryText = responseString
                }
                
                let responseResult = "성공: \(result)"
                completion(.success(responseResult))
                
            case .failure(let error):
                SharedData.shared.summaryText = "\(error.localizedDescription)\n위의 이유로 GPT를 이용한 요약을 수행할 수 없습니다."
                completion(.failure(CustomError.badGPTRunError(error: error as NSError)))
            }
        }

    }
}

