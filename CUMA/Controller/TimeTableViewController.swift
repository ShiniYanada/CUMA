//
//  TimeTableViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/24.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//
//時間割を表示しているView

import UIKit
import RealmSwift

class TimeTableViewController: UIViewController {
    @IBOutlet weak var timeTableCollectionView: UICollectionView!
    @IBOutlet weak var dayStackView: UIStackView!
    
    let fullNameDays = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
    let hoursName = ["1限", "2限", "3限", "4限", "5限", "6限", "7限"]
    //表示する曜日の数
    var numberOfDays = 5
    //表示する曜日の時限数
    var numberOfHours = 6
    //時限の開始時間と終了時間の配列
    let startTimes = ["08:50", "10:30", "12:50", "14:30", "16:10", "17:50", "19:30"]
    let finishTimes = ["10:20", "12:00", "14:20", "16:00", "17:40", "19:20", "21:00"]
    
    let hourWidth: CGFloat = 60
    let timeTableHeight: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTableCollectionView.delegate = self
        timeTableCollectionView.dataSource = self
        
        timeTableCollectionView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellWithReuseIdentifier: "TimeTableCell")
        timeTableCollectionView.register(UINib(nibName: "HourCell", bundle: nil), forCellWithReuseIdentifier: "HourCell")
        
        let realm = try! Realm()
        let timeTable = realm.objects(TimeTable.self).filter("selected == true").first!
        numberOfDays = timeTable.day
        numberOfHours = timeTable.hour
        navigationItem.title = timeTable.name

        switch numberOfDays {
        case 5:
            self.dayStackView.arrangedSubviews[5].isHidden = true
            self.dayStackView.arrangedSubviews[6].isHidden = true
        case 6:
            self.dayStackView.arrangedSubviews[6].isHidden = true
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        timeTableCollectionView.collectionViewLayout = createCompositionalLayout()
        super.viewDidLayoutSubviews()
    }
        
    //画面遷移前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath: IndexPath!, day: String = "", hour: String = ""
        if sender is IndexPath {
            indexPath = sender as? IndexPath
            let dayIndex = indexPath.row % (numberOfDays + 1) - 1
            let hourIndex = indexPath.row / (numberOfDays + 1)
            day = fullNameDays[dayIndex]
            hour = hoursName[hourIndex]
        }
        // 検索画面遷移では、曜日と時限の文字列、選択されたindexPathを渡す。
        if segue.identifier == "TimeTableSearchSegue" {
            let timeTableSearchViewController: TimeTableSearchViewController = segue.destination as! TimeTableSearchViewController
            timeTableSearchViewController.day = day
            timeTableSearchViewController.hour = hour
            timeTableSearchViewController.indexPath = indexPath
        } else if segue.identifier == "RegisteredClassSegue" {
            let registeredClassViewController: RegisteredClassViewController = segue.destination as! RegisteredClassViewController
            registeredClassViewController.day = day
            registeredClassViewController.hour = hour
            registeredClassViewController.indexPath = indexPath
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let houtItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(hourWidth), heightDimension: .fractionalHeight(1.0)))
        houtItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 1)
        
        let dayItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0)))
        
        let dayGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(timeTableCollectionView.frame.width - hourWidth), heightDimension: .fractionalHeight(1.0)), subitem: dayItem, count: numberOfDays)
        
        dayGroup.interItemSpacing = .fixed(2)
        
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(timeTableHeight)), subitems: [houtItem, dayGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        section.interGroupSpacing = 2
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    // 時間割の変更、設定を更新した際に再表示する
    func changeTimeTable() {
        let realm = try! Realm()
        let timeTable = realm.objects(TimeTable.self).filter("selected = true").first
        numberOfDays = timeTable!.day
        numberOfHours = timeTable!.hour
        navigationItem.title = timeTable!.name
        switch numberOfDays {
        case 5:
            self.dayStackView.arrangedSubviews[5].isHidden = true
            self.dayStackView.arrangedSubviews[6].isHidden = true
        case 6:
            self.dayStackView.arrangedSubviews[5].isHidden = false
            self.dayStackView.arrangedSubviews[6].isHidden = true
        case 7:
            self.dayStackView.arrangedSubviews[5].isHidden = false
            self.dayStackView.arrangedSubviews[6].isHidden = false
        default:
            break
        }
        timeTableCollectionView.collectionViewLayout = createCompositionalLayout()
        timeTableCollectionView.reloadData()
    }
}

extension TimeTableViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (numberOfDays + 1) * numberOfHours
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row % (numberOfDays + 1) == 0) {
            let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
            let hour = indexPath.row / (numberOfDays + 1) + 1
            hourCell.hourLabel.text = String(hour)
            hourCell.startTimeLabel.text = startTimes[hour - 1]
            hourCell.finishTimeLabel.text = finishTimes[hour - 1]
            hourCell.backgroundColor = .blue
            return hourCell
        } else {
            let timeTableCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCell", for: indexPath) as! TimeTableCell
            let day = fullNameDays[indexPath.row % (numberOfDays + 1) - 1]
            let hour = hoursName[indexPath.row / numberOfHours]
            let realm = try! Realm()
            let timetable = realm.objects(TimeTable.self).filter("selected == true").first!
            if let lesson = timetable.classes.filter("day == %@ && hour == %@", day, hour).first {
                timeTableCell.classNameLabel.text = lesson.name
                timeTableCell.roomLabel.text = lesson.room
            } else {
                timeTableCell.classNameLabel.text = ""
                timeTableCell.roomLabel.text = ""
            }
            timeTableCell.backgroundColor = .blue
            return timeTableCell
        }
        
    }
}

extension TimeTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if (indexPath.row % (numberOfDays + 1) == 0) {
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! TimeTableCell
        if item.classNameLabel.text! == "" {
            performSegue(withIdentifier: "TimeTableSearchSegue", sender: indexPath)
        } else {
            performSegue(withIdentifier: "RegisteredClassSegue", sender: indexPath)
        }
        print("Selected: \(indexPath.row)")
    }
}
