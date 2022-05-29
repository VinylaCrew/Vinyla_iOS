//
//  UIButton+.swift
//  Vinyla
//
//  Created by Zio.H on 2022/04/30.
//

import UIKit

extension UIButton {
    //버튼 터치 영역 늘리기
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //        print(self.bounds.size)
        var marginWidth: CGFloat = 0
        var marginHeight: CGFloat = 0
        if self.bounds.size.width < 44 {
            marginWidth = 44 - self.bounds.size.width
        }
        
        if self.bounds.size.height < 44 {
            marginHeight = 44 - self.bounds.size.height
        }
        
        if self.bounds.size.width == 24 && self.bounds.size.height == 24 {
            /// 회원 가입 버튼은 마진 주지 않도록 설계
            marginWidth = 0
            marginHeight = 0
        }
        
        let hitArea = self.bounds.insetBy(dx: -marginWidth, dy: -marginHeight)
        return hitArea.contains(point)
    }
    
    func setupUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
