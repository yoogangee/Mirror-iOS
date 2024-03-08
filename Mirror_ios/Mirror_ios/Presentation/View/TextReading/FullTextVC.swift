//
//  FullTextVC.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/08.
//

import UIKit
import SnapKit

class FullTextVC: BaseController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    
    // TextReadingVC의 isExistSummary 변수 값 접근에 사용할 delegate
    weak var textReadingDelegate: TextReadingDelegate?
    
    let infoLabel: UILabel = {
       let label = UILabel()
        
        label.text = "아래 내용은 추출한 문서 전문입니다.\n다른 문서를 인식하시거나 다른 기능을 이용하시려면 하단 파란색 [뒤로가기] 버튼을 클릭하세요."
        label.textColor = UIColor.customBlack
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.setLineSpacing(spacing: 4)
        
        return label
    }()
    
    let backBtn: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 8
        button.setTitle("뒤로 가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(clickedbackBtn), for: .touchUpInside)
        
        return button
    }()
    
    let fullTextLabel: ScrollPaddingLabel = {
        let view = ScrollPaddingLabel(padding: UIEdgeInsets(top: 19, left: 20, bottom: 19, right: 20))
        
        view.setText(SharedData.shared.recognizedFullText)
        
        return view
    }()
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        view.backgroundColor = UIColor.customWhite
        
        self.title = "문서 전문 보기"

        navigationItem.hidesBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func addview() {
        view.addSubview(infoLabel)
        view.addSubview(backBtn)
        view.addSubview(fullTextLabel)
    }
    
    override func layout() {
        infoLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 12, left: 23, bottom: 0, right: 23))
        }
        
        backBtn.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 23, bottom: 16, right: 23))
            make.height.equalTo(55)
        }
        
        fullTextLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23))
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.bottom.equalTo(backBtn.snp.top).offset(-19)
        }
    }
    
    @objc func clickedbackBtn() {
        print("뒤로!")
        
        textReadingDelegate?.upDateisExistSummary(false)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의

}
