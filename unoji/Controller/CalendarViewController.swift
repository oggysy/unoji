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
    let realm = try! Realm()
    var objects: Results<WashTimeModel>?
    private var df = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
    }

    // 日付のセルに画像を表示させる
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        df.dateFormat = "yyyy-MM-dd"
        guard let objects = objects else {
            return nil }
        let matchObject = objects.first(where: { $0.washDay == df.string(from: date) })
        if matchObject != nil {
            let image = UIImage(named: matchObject!.displayIllustration + "icon")
            return image
        } else {
            return nil
        }
    }
    // 日付のセルに枠線をつける
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
        cell.layer.borderColor = UIColor(white: 200 / 255.0, alpha: 0.5).cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.backgroundColor = UIColor.init(red: 255 / 255, green: 249 / 255, blue: 230 / 255, alpha: 0.4).cgColor

        if Calendar.current.isDateInToday(date) {
            cell.layer.borderColor = UIColor.init(red: 236 / 255, green: 85 / 255, blue: 120 / 255, alpha: 1.0).cgColor
                cell.layer.borderWidth = 2.0
            }
        return cell
    }

    // viewDidLoad時に行う処理
    private func configure() {
        objects = realm.objects(WashTimeModel.self)
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        calendar.appearance.titleOffset = CGPoint(x: -10, y: -14)
        let weekText = ["日", "月", "火", "水", "木", "金", "土"]
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = weekText[i]
        }
    }
}
