//
//  FindObjectVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import SnapKit

class FindObjectVC: BaseController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    lazy var navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "물건 찾기"
        navigationTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        navigationTitle.textColor = .black
        return navigationTitle
    }()
    
    lazy var informLabel: UILabel = {
        let informLabel = UILabel()
        informLabel.text = "찾고싶은 물건을 말씀해주세요"
        informLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        informLabel.textColor = .black
        return informLabel
    }()
    
    lazy var recordImg: UIImageView = {
        let recordImg = UIImageView()
        recordImg.image = UIImage(named: "recordImage")
        return recordImg
    }()
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        self.navigationItem.titleView = navigationTitle
        
        let nextBtn = UIBarButtonItem(title: "다음", style: .done, target: self, action: #selector(openCamera))
        self.navigationItem.rightBarButtonItem = nextBtn
    }
    
    override func addview() {
        view.addSubview(informLabel)
        view.addSubview(recordImg)
    }
    
    override func layout() {
        informLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        recordImg.snp.makeConstraints { make in
            make.width.height.equalTo(170)
            make.centerX.equalToSuperview()
            make.top.equalTo(informLabel.snp.bottom).offset(130)
        }
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의
    @objc func openCamera() {
        let findObjectCameraVC = FindObjectCameraVC()
        navigationController?.pushViewController(findObjectCameraVC, animated: true)
    }
}
