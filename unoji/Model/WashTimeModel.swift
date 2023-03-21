//
//  WashTimeModel.swift
//  unoji
//
//  Created by 小木曽佑介 on 2023/03/08.
//

import Foundation
import RealmSwift

class WashTimeModel: Object {
    @objc dynamic var washTime: Date? // 流すアクションをした時刻を記録
    @objc dynamic var washDay: String = ""// FSCalender用に年月日を文字列に
    @objc dynamic var elapsedTime: Int = 0// 経過時間
    @objc dynamic var displayIllustration: String = "baby"// 経過時間に応じたイラスト名を文字列で
}

extension WashTimeModel {
    // 最後にRealmに記録されたデータを元にelapsedTimeとdisplayIllustrationの値を更新する
    func setValue(lastTime: Date) {
        elapsedTime = Int(abs(lastTime.timeIntervalSinceNow))
        setDisplayIlustration()
    }

    // 経過時間によってイラストの名前を分岐してdisplayIllustrationに代入
    func setDisplayIlustration() {
        let elapsedHour = elapsedTime / 3600
        switch elapsedHour {
        case 0..<12:// 0~12時間はbaby
            displayIllustration = "baby"
        case 12..<24:// 12~24時間はboy
            displayIllustration = "boy"
        case 24..<48:// 24~48時間はoji1
            displayIllustration = "oji1"
        case 48...:
            displayIllustration = "oji2"// 48時間以上はoji2
        default:
            displayIllustration = "baby"
        }
    }

    // FSCalender表示用にwashTimeを年月日に直してwashDayに代入
    func setWashTime() {
        washTime = Date()
        guard let washTime = washTime else { return }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        washDay = df.string(from: washTime)
    }

    // 経過時間(秒数)を00日00時間の形式に変換
    func elapsedTimeConvertForDisplay() -> String {
        let days = elapsedTime / 86400
        let hours = (elapsedTime % 86400 ) / 3600
        let formattedTime = String(format: "%02d日%02d時間", days, hours)
        return "\(formattedTime)経過"
    }
}
