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
    private let label = UILabel()
    private let padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
        configureLabel()
        configureScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            label.widthAnchor.constraint(equalTo: widthAnchor, constant: -(padding.left+padding.right))
        ])
    }
    
    private func configureScrollView() {
        self.showsVerticalScrollIndicator = true

        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.customGray2.cgColor
    }
    
    func setText(_ text: String) {
        label.text = text
        
        label.sizeToFit()
        contentSize = CGSize(width: label.bounds.width + padding.left + padding.right, height: label.bounds.height + padding.top + padding.bottom)
    }
    
    func getText() -> String? {
        return label.text
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
