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
    @objc dynamic var elapsedTime = 0// 経過時間
}

extension WashTimeModel {
    // 最後にRealmに記録されたデータを元にelapsedTimeの値を更新する
    func update(by lastTime: Date) {
        elapsedTime = Int(abs(lastTime.timeIntervalSinceNow))
    }

    // 経過時間によってイラストの名前を文字列を返す
    func setDisplayIlustration() -> String {
        let elapsedHour = elapsedTime / 3600
        switch elapsedHour {
        case 0..<12:// 0~12時間はbaby
            return "baby"
        case 12..<24:// 12~24時間はboy
            return "boy"
        case 24..<48:// 24~48時間はoji1
            return "oji1"
        case 48...:
            return "oji2"// 48時間以上はoji2
        default:
            return "baby"
        }
    }

    // WashTimeを現在時刻にセット
    func setWashTime() {
        washTime = Date()
    }

    // FSCalendar用に流した年月日の文字列に変換する
    func formatWashTime () -> String {
        guard let washTime = washTime else {
            return ""
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: washTime)
    }

    // 経過時間(秒数)を00日00時間の形式に変換
    func formatElapsedTime() -> String {
        let days = elapsedTime / 86400
        let hours = (elapsedTime % 86400 ) / 3600
        let formattedTime = String(format: "%02d日%02d時間", days, hours)
        return "\(formattedTime)経過"
    }

    // washTimeをセットしてrealmに保存し、新しいWashTimeModelをインタンス化して返すスタティックメソッド
    static func saveAndCreateWashTime(model: WashTimeModel) -> WashTimeModel {
        model.setWashTime()
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            print(error)
        }
        return WashTimeModel()
    }
}
