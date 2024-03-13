//
//  NetworkManager.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/13.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let api = NetworkAPI()
    private let session = URLSession(configuration: .default)
    
    
    func getImageCaption(image: UIImage, completion: @escaping (Result<String, CustomError>) -> (Void)) {
        
        print("이미지 캡션 문장 만들기 시작")
        
        // 이미지 파일 관련 통신은  timeout 정책을 채택하는 것이 좋음
        session.configuration.timeoutIntervalForRequest = TimeInterval(20)
        session.configuration.timeoutIntervalForResource = TimeInterval(20)
        
        // url 생성
        guard let url = api.getImageCaptionAPI() else {
            completion(.failure(CustomError.badURL))
            return
        }
        
        // URLRequest로 dataTask 만들기
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        
        // Header setting
        let uniqString = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(uniqString)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // form data setting
        
        // 이미지 데이터 생성
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            completion(.failure(CustomError.noImageData))
            return
        }
        // 폼 데이터 생성
        var body = Data()

        // 멀티 파트 데이터의 구분자(boundary)
        body.append("--\(uniqString)\r\n".data(using: .utf8)!)

        // 멀티 파트 데이터의 파트에 대한 헤더를 추가: name 파라미터를 "image"로 설정하고, 업로드된 파일의 원래 이름을 "image.jpg"로 설정
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)

        // 업로드된 파일의 MIME 타입을 명시
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)

        // 실제 이미지 바이너리 데이터를 담고있는 값 추가
        body.append(imageData)

        //  각 파트 사이에 빈 줄을 추가하여 파트를 구분하며 멀티파트 데이터의 각 파트를 구분하는 구분자 역할
        body.append("\r\n".data(using: .utf8)!)

        // 멀티파트 데이터의 끝을 나타내는 경계값을 추가하며 멀티파트 데이터의 마지막을 나타내고 파트들을 닫는 역할
        body.append("--\(uniqString)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: request, from: body) { (data, response, error) in
            guard error == nil else {
                print(error ?? "에러 없음")
                completion(.failure(CustomError.urlSessionError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CustomError.responseError))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(CustomError.responseCodeError(code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.noResultError))
                return
            }
            do {
                let responseString = try JSONDecoder().decode(String.self, from: data)
                completion(.success(responseString))
            } catch let error as NSError {
                completion(.failure(CustomError.decodingError(error: error)))
            }
        }.resume()
        
    }
}

