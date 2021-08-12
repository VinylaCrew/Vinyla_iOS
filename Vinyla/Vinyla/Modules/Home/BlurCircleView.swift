//
//  BlurCircleView.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/09.
//

import UIKit

class BlurCircleView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var shownCircleImageView: UIImageView!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup() //안걸림
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // xibSetup() // 하면 storyboard에서 실시간(컴파일타임)에 inspector창에서 변경해도 확인 불가
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shownCircleImageView.layer.cornerRadius = shownCircleImageView.frame.height/2
        print(self.superview?.frame.height)
        print("bounds height/2")
        print(shownCircleImageView.bounds.height/2)
        print(self.layer.bounds)
    }
    
    override func awakeFromNib() {
//        shownCircleImageView.layer.cornerRadius = shownCircleImageView.frame.height/2
        print("awakefromnib")
        print(self.superview?.frame.height)
//        print("bounds height/2")
//        print(shownCircleImageView.bounds.height/2)
//        print(self.layer.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib(nib: "BlurCircleView") else {
            return
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
