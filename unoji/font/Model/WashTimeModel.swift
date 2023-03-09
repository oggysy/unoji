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
        case 0...10:
            return "baby"
        case 11...20:
            return "boy"
        case 21...30:
            return "oji1"
        case 31...:
            return "oji2"
        default:
            return "baby"
        }
    }

    // 経過時間(秒数)を日時分秒に変換
    func elapsedTimeConvertForDisplay() -> String {
        let days = elapsedTime / 86400
        let hours = (elapsedTime % 86400) / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        let formattedTime = String(format: "%02d日%02d時間%02d分%02d秒", days, hours, minutes, seconds)
        return formattedTime
    }
}
