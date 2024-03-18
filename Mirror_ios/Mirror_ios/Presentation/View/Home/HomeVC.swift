//
//  HomeVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import SnapKit

class HomeVC: BaseController {
    
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "\"미로:Mirror\""
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.text = "이미지 묘사, 물건 찾기, 문서 읽기\n총 3가지의 기능을 제공합니다.\n각 기능은 어플 하단 네비게이션 바를 통해\n홈 / 물건 찾기 / 이미지 설명 / 문서 읽기\n순으로 사용하실 수 있습니다.\n왼쪽 오른쪽으로 슬라이드 하거나\n하단 네비게이션 바를 클릭하여\n해당 기능으로 이동 가능합니다."
        contentLabel.textColor = .black
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        contentLabel.setLineSpacing(spacing: 4)
        contentLabel.textAlignment = .center
        return contentLabel
    }()
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TTS.shared.stop()
        TTS.shared.play("이미지 묘사, 물건 찾기, 문서 읽기 총 세가지의 기능을 제공합니다. 각 기능은 어플 하단 네비게이션 바를 통해 홈 / 물건 찾기 / 이미지 설명 / 문서 읽기 순으로 사용하실 수 있습니다. 왼쪽 오른쪽으로 슬라이드 하거나 하단 네비게이션 바를 클릭하여 해당 기능으로 이동 가능합니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        
    }
    
    override func addview() {
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(270)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.top).offset(100)
        }
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의
}
