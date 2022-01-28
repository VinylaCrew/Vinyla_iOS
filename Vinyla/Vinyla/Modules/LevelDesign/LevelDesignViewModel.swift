//
//  LevelDesignViewModel.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/29.
//

import Foundation

final class LevelDesignViewModel {
    var levelDesignCellID: String = "LevelDesignCell"
    var levelDesignModel: [LevelDesignModel] = [LevelDesignModel]()

    init() {
        print("init leveldesign viewmodel",CFGetRetainCount(self))
        levelDesignModel.append(LevelDesignModel(levelImageName: "icnHomeLv1", level: "LV.1", levelName: "닐페이스 (0~1)", levelMent: "바이닐과 밀당의 시작"))
        levelDesignModel.append(LevelDesignModel(levelImageName: "icnHomeLv2", level: "LV.2", levelName: "닐리즈 (1~9)", levelMent: "바이닐 수집의 매력을 알게된 리즈시절"))
        levelDesignModel.append(LevelDesignModel(levelImageName: "icnHomeLv3", level: "LV.3", levelName: "닐스터 (10~49)", levelMent: "바이닐 수집에 진심인 힙스터"))
        levelDesignModel.append(LevelDesignModel(levelImageName: "icnHomeLv4", level: "LV.4", levelName: "닐암스트롱 (50~499)", levelMent: "바이닐 정복에 첫 발을 디딘 콜렉터"))
        levelDesignModel.append(LevelDesignModel(levelImageName: "icnHomeLv5", level: "LV.5", levelName: "닐라대왕 (500~)", levelMent: "이 세상 모든 바이닐을 손에 넣은 레전드"))
    }

    deinit {
        print("deinit LevelDesignViewModel")
    }
}
