//
//  UIViewController+LoadingIndicator.swift
//  Vinyla
//
//  Created by IJ . on 2021/12/02.
//

import UIKit

fileprivate var loadingGreyView : UIView?

extension UIViewController {
    func ShowLoadingIndicator() {
        loadingGreyView = UIView(frame: self.view.bounds)
        loadingGreyView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        guard let loadingView = loadingGreyView else { return }
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        loadingGreyView?.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
    }

    func removeLoadingIndicator() {
        loadingGreyView?.removeFromSuperview()
        loadingGreyView = nil
    }
}
