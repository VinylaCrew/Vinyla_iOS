//
//  UIViewController+LoadingIndicator.swift
//  Vinyla
//
//  Created by IJ . on 2021/12/02.
//

import UIKit

fileprivate var loadingGreyView : UIView?

extension UIViewController {
    func showLoadingIndicator() {
        self.removeLoadingIndicator()
        loadingGreyView = UIView(frame: self.view.bounds)
        loadingGreyView?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
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
