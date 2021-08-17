//
//  HomeViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/05.
//

import Foundation

class HomeViewModel {
    var homeStirng: String?
    init() {
        self.homeStirng = "test"
        print("init homeviewmodel",self.homeStirng)
    }

    deinit {
        print("deinit HomeViewModel")
    }
}
