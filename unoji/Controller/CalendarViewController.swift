//
//  CalenderViewController.swift
//  unoji
//
//  Created by 小木曽佑介 on 2023/03/16.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    @IBOutlet weak var calendar: FSCalendar!
    private var realm = try! Realm()
    private var objects: Results<WashTimeModel>?
    private var notificationToken: NotificationToken?
    private var df = DateFormatter()
    private var currentDay: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentDay = currentDay else {
            return
        }
        // currentDayが今日の日付になっていなければcalendarをリロード
        if !Calendar.current.isDateInToday(currentDay) {
            calendar.reloadData()
        }
    }

    deinit {
        // NotificationTokenを解除
        notificationToken?.invalidate()
    }

    // 日付のセルに画像を表示させる
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        guard let objects = objects else {
            return nil
        }
        let matchObject = objects.first(where: { $0.formatWashTime() == df.string(from: date) })
        guard let matchObject = matchObject else {
            return nil
        }
        return UIImage(named: matchObject.setDisplayIlustration() + "icon")
    }

    // 日付のセルに枠線と背景色をつける
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
        cell.layer.borderColor = UIColor(white: 200 / 255.0, alpha: 0.5).cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.backgroundColor = UIColor.init(red: 255 / 255, green: 249 / 255, blue: 230 / 255, alpha: 0.4).cgColor

        if Calendar.current.isDateInToday(date) {
            currentDay = date
            cell.layer.borderColor = UIColor.init(red: 236 / 255, green: 85 / 255, blue: 120 / 255, alpha: 1.0).cgColor
            cell.layer.borderWidth = 2.0
        }
        return cell
    }

    // viewDidLoad時に行う処理
    private func configure() {
        df.dateFormat = "yyyy-MM-dd"
        objects = realm.objects(WashTimeModel.self)
        // RealmのNotificationを設定
        notificationToken = objects?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else {
                return
            }
            switch changes {
            case .initial:
                // 初期データの読み込み
                self.calendar.reloadData()
            case .update:
                // データの更新
                self.calendar.reloadData()
            case .error(let error):
                // エラー
                fatalError("\(error)")
            }
        }
        // cellFor関数用にforCellReuseIdentifierを設定
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        // カレンダーの見た目をカスタマイズ
        calendar.appearance.titleOffset = CGPoint(x: -10, y: -14)
        let weekText = ["日", "月", "火", "水", "木", "金", "土"]
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = weekText[i]
        }
    }
}
