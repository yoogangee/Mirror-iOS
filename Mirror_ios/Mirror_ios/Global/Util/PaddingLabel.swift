//
//  PaddingLabel.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/06.
//

import UIKit

class PaddingLabel: UILabel {

    private var padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    
    convenience init(padding: UIEdgeInsets) {
            self.init()
            self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        let paddingRect = rect.inset(by: padding)
        super.drawText(in: paddingRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }

}

class ScrollPaddingLabel: UIScrollView {
    private var padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    private let label = UILabel()

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
        configureLabel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
        configureScrollView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
        configureScrollView()
    }

    private func configureLabel() {
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.customBlack
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.lineBreakMode = .byCharWrapping
        label.setLineSpacing(spacing: 4)
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
        ])
    }
    
    private func configureScrollView() {
        self.showsVerticalScrollIndicator = true
        
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.customGray2.cgColor
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentSize = label.bounds.size
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}
