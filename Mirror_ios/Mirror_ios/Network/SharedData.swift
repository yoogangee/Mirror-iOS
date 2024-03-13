//
//  SharedData.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/09.
//

import Foundation
import UIKit

class SharedData {
    static let shared = SharedData()
    var recognizedFullText: String = ""
    var summaryText: String = ""
    var explainText: String = ""
}
