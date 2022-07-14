//
//  UIView+Gradient.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/29.
//

import UIKit

extension UIView {
    func setGradient(color1:UIColor, color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
//        layer.addSublayer(gradient)
        layer.insertSublayer(gradient, at: 0)
    }
}
