//
//  WashTimeModel.swift
//  unoji
//
//  Created by 小木曽佑介 on 2023/03/08.
//

import Foundation

class WashTimeModel {
    var washTime: Date? // 流すアクションをした時刻を記録
    // 前回流すアクションをしてから現在までの経過時間
    var elapsedTime: Int {
        guard let washTime = washTime else {
            return 0 }
        return Int(abs(washTime.timeIntervalSinceNow))
    }
    // 経過時間によってイラストの名前を分岐して返す
    var displayIllustration: String {
        switch elapsedTime {
        case 0...43200:// 0~12時間はbaby
            return "baby"
        case 43201...86400:// 12~24時間はboy
            return "boy"
        case 86401...172800:// 24~48時間はoji1
            return "oji1"
        case 172801...:
            return "oji2"// 48時間以上はoji2
        default:
            return "baby"
        }
    }

    // 経過時間(秒数)を00日00時間の形式に変換
    func elapsedTimeConvertForDisplay() -> String {
        let days = elapsedTime / 86400
        let hours = (elapsedTime % 86400) / 3600
        let formattedTime = String(format: "%02d日%02d時間", days, hours)
        return "\(formattedTime)経過"
    }
}