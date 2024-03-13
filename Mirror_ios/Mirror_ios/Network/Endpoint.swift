//
//  Endpoint.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/13.
//

import Foundation
import UIKit

enum Endpoint {
    static let serverURL = ""
}

struct NetworkAPI {
    static let schema = "http"
    static let host = "127.0.0.1:8000"
    static let path = "captioning"

//    func getImageCaptionAPI() -> URLComponents {
//
//        var components = URLComponents()
//        components.scheme = NetworkAPI.schema
//        components.host = NetworkAPI.host
//        components.path = NetworkAPI.path
//
//        return components
//    }
    
    func getImageCaptionAPI() -> URL? {
//        return URL(string: "\(NetworkAPI.schema)://\(NetworkAPI.host)/\(NetworkAPI.path)")
        return URL(string: "http://localhost:8000/captioning")
    }
}
