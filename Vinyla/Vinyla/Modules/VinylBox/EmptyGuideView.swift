//
//  EmptyGuidView.swift
//  Vinyla
//
//  Created by IJ . on 2022/04/04.
//

import UIKit

final class EmptyGuideView: UIView {

    @IBOutlet weak var guideLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alternativeCustomInit()
        setGuideLabelAttributedText()
        print("override init")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        alternativeCustomInit()
        setGuideLabelAttributedText()
        print("required init")
    }

    private func alternativeCustomInit() {
        if let view = UINib(nibName: "EmptyGuideView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }

    private func setGuideLabelAttributedText() {
        guard let guideLabelText = guideLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: guideLabelText)
        let font = UIFont(name: "NotoSansKR-Regular", size: 13)
        attributedString.addAttribute(.font, value: font, range: (guideLabelText as NSString).range(of:"우측 하단 +버튼을 통해 바이닐 보관함을 채워보세요!"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: (guideLabelText as NSString).range(of:"+버튼"))

        self.guideLabel.attributedText = attributedString
    }

}
