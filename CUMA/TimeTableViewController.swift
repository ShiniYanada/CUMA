//
//  TimeTableViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/24.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit
import WebKit

class TimeTableViewController: UIViewController {
    @IBOutlet weak var timeTableCollectionView: UICollectionView!
    
    //曜日の配列
    let days = ["", "月", "火", "水", "木", "金", "土", "日"]
    let fullNameDays = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    let hoursName = ["１限", "２限", "３限", "４限", "５限", "６限", "7限"]
    //表示する曜日の数
    let numberOfDays = 5
    //表示する曜日の時限数
    let numberOfHours = 6
    //時限の開始時間と終了時間の配列
    let startTimes = ["08:50", "10:30", "12:50", "14:30", "16:10", "17:50", "19:30"]
    let finishTimes = ["10:20", "12:00", "14:20", "16:00", "17:40", "19:20", "21:00"]
    
    let hourWidth: CGFloat = 60
    let dayHeight: CGFloat = 40
    let timeTableHeight: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTableCollectionView.delegate = self
        timeTableCollectionView.dataSource = self
        
        timeTableCollectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        timeTableCollectionView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellWithReuseIdentifier: "TimeTableCell")
        timeTableCollectionView.register(UINib(nibName: "HourCell", bundle: nil), forCellWithReuseIdentifier: "HourCell")
    }
    
    override func viewDidLayoutSubviews() {
        timeTableCollectionView.collectionViewLayout = createCompositionalLayout()
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TimeTableSearchSegue" {
            let indexPath = sender as! IndexPath
            let timeTableInputViewController: TimeTableSearchViewController = segue.destination as! TimeTableSearchViewController
            let dayIndex = indexPath.row % (numberOfDays + 1) - 1
            let hourIndex = indexPath.row / (numberOfDays + 1)
            timeTableInputViewController.navigationItem.title = "\(fullNameDays[dayIndex]) \(hoursName[hourIndex])"
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment)
              -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                return self.createDayLayout()
            case 1:
                return self.createTimeTableLayout()
            default:
                return self.createTimeTableLayout()
            }
        }
        return layout
        
    }
    
    func createDayLayout() -> NSCollectionLayoutSection {
        let houtItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(hourWidth), heightDimension: .fractionalHeight(1.0)))
        
        let dayItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0)))
        
        let dayGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(timeTableCollectionView.frame.width - hourWidth), heightDimension: .fractionalHeight(1.0)), subitem: dayItem, count: numberOfDays)
        
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(dayHeight)), subitems: [houtItem, dayGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        return section
    }
    
    func createTimeTableLayout() -> NSCollectionLayoutSection {
        let houtItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(hourWidth), heightDimension: .fractionalHeight(1.0)))
        
        let dayItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0)))
        
        let dayGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(timeTableCollectionView.frame.width - hourWidth), heightDimension: .fractionalHeight(1.0)), subitem: dayItem, count: numberOfDays)
        
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(timeTableHeight)), subitems: [houtItem, dayGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        return section
    }
}

extension TimeTableViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return numberOfDays + 1
        } else {
            return (numberOfDays + 1) * numberOfHours
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellforitemat")
        if (indexPath.section == 0) {
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
            dayCell.backgroundColor = .red
            dayCell.dayLabel.text = days[indexPath.row]
            return dayCell
        } else {
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
                timeTableCell.backgroundColor = .blue
                return timeTableCell
            }
        }
    }
    
    
}

extension TimeTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else if (indexPath.row % (numberOfDays + 1) == 0){
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TimeTableSearchSegue", sender: indexPath)
        print("Selected: \(indexPath.row)")
    }
}
