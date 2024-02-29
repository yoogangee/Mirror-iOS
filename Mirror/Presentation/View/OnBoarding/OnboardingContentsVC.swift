//
//  OnboardingContentsVC.swift
//  Mirror
//
//  Created by 경유진 on 2/28/24.
//

import UIKit

class OnboardingContentsVC: BaseController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    private var stackView: UIStackView!
        
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var contentLabel = UILabel()
    
    init(imageName: String, title: String, content: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        contentLabel.text = content
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        contentLabel.numberOfLines = 0
        contentLabel.setLineSpacing(spacing: 4)
        contentLabel.textAlignment = .center
        
        self.stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, contentLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(100, after: imageView)
        stackView.setCustomSpacing(30, after: titleLabel)
    }
    
    override func addview() {
        view.addSubview(stackView)
    }
    
    override func layout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
        }
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의
}

// UILabel 행간 조절하기 위한 extension
extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
