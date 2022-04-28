//
//  BlurCircleView.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/09.
//

import UIKit

protocol ButtonTapDelegate: AnyObject {
    func didTapFavoriteButton(sender: UIButton)
    func didTapPopButton()
    func didTapInstagramButton()
}

final class BlurCircleView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var shownCircleImageView: UIImageView!
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var setFavoriteImageButton: UIButton!
    @IBOutlet weak var InstagramShareButton: UIButton!
    @IBOutlet weak var myVinylGuideLabel1: UILabel!
    @IBOutlet weak var myVinylGuideLabel2: UILabel!
    @IBOutlet weak var myVinylGuideImageView: UIImageView!

    weak var delegate: ButtonTapDelegate?
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
    }
    
    override func awakeFromNib() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        self.myVinylGuideLabel1.isHidden = true
        self.myVinylGuideLabel2.isHidden = true
        self.myVinylGuideImageView.isHidden = true
    }
    
    @IBAction func touchUpsetFavoriteButton(_ sender: UIButton) {
//        if self.setFavoriteImageButton.isSelected {
//            self.setFavoriteImageButton.isSelected = false
//        }else {
//            self.setFavoriteImageButton.isSelected = true
//        }
        self.delegate?.didTapFavoriteButton(sender: self.setFavoriteImageButton)
    }
    @IBAction func touchUpPoPButton(_ sender: UIButton) {
        self.delegate?.didTapPopButton()
    }
    @IBAction func touchUpInstagramShareButton(_ sender: UIButton) {
        self.delegate?.didTapInstagramButton()
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

    func hideMyVinylGuideItem() {
        self.myVinylGuideLabel1.isHidden = true
        self.myVinylGuideLabel2.isHidden = true
        self.myVinylGuideImageView.isHidden = true
    }

    func showMyVinylGuideItem() {
        self.myVinylGuideLabel1.isHidden = false
        self.myVinylGuideLabel2.isHidden = false
        self.myVinylGuideImageView.isHidden = false
    }
    
}
