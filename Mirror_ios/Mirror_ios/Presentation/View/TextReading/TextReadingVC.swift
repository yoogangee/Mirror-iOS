//
//  TextReadingVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import VisionKit

class TextReadingVC: BaseController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet

    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "문서읽기"

    }
    
    override func addview() {
    }
    
    override func layout() {
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의

}
