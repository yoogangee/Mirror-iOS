//
//  UILabel+.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit

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

