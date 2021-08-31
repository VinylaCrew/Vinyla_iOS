//
//  UIColor+Extension.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/20.
//

import UIKit

extension UIColor {
    class func buttonDisabledColor() -> UIColor {
        return UIColor(red: 35/255, green: 35/255, blue: 36/255, alpha: 1)
    }
    class func vinylaMainOrangeColor() -> UIColor {
        return UIColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1)
    }
    static func buttonDisabledTextColor() -> UIColor {
        return UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    }
    static func gradientStartColor() -> UIColor {
        return UIColor(red: 255/255, green: 76/255, blue: 0/255, alpha: 0.18)
    }
    static func gradientEndColor() -> UIColor {
        return UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 0.2)
    }
    static func textColor() -> UIColor {
        return UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
    }
}
