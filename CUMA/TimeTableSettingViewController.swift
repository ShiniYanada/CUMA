//
//  TimeTableSettingViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/12/08.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit
import RealmSwift

class TimeTableSettingViewController: UIViewController {

    let settingTitles = [["時間割名"], ["曜日", "時限"]]
    let dayItems = ["平日のみ", "平日+土", "平日+土日"]
    let hourItems = ["5", "6", "7", "8", "9", "10"]
    var timeTableName: String?
    var timeTableDayIndex: Int?
    var timeTableHourIndex: Int?
    var timeTable: TimeTable!
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func clickCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let isNameChanged = timeTableName != nil ? true : false
        let isDayChanged = timeTableDayIndex != nil ? true : false
        let isHourChanged = timeTableHourIndex != nil ? true : false
        
        try! realm.write {
            if isNameChanged {
                timeTable.name = timeTableName!
            }
            if isDayChanged {
                timeTable.days = timeTableDayIndex! + 5
            }
            if isHourChanged {
                timeTable.hours = timeTableHourIndex! + 5
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        timeTable = realm.objects(TimeTable.self).filter("selected == true").first
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SellectingDaySegue") {
            let timeTableSettingDayItemViewController: TimeTableSettingDayItemViewController = segue.destination as! TimeTableSettingDayItemViewController
            timeTableSettingDayItemViewController.navigationItem.title = "曜日の変更"
            // dayItemsのIndexを送る
            timeTableSettingDayItemViewController.dayIndex = timeTableDayIndex ?? timeTable.days - 5
        } else if (segue.identifier == "SellectingPeriodSegue") {
            let timeTableSettingPeriodItemViewController: TimeTableSettingHourItemViewController = segue.destination as! TimeTableSettingHourItemViewController
            timeTableSettingPeriodItemViewController.navigationItem.title = "最大時限数"
            // hourItemsのIndexを送る
            timeTableSettingPeriodItemViewController.hourIndex = timeTableHourIndex ?? timeTable.hours - 5
        }
    }
}

extension TimeTableSettingViewController: UITableViewDelegate {
}

extension TimeTableSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableSettingInputCell", for: indexPath)
        cell.textLabel?.text = self.settingTitles[indexPath.section][indexPath.row]
        if (indexPath.section == 0) {
            cell.detailTextLabel?.text = timeTableName ?? timeTable.name
        } else {
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = dayItems[timeTableDayIndex ?? timeTable.days - 5]
            default:
                cell.detailTextLabel?.text = hourItems[timeTableHourIndex ?? timeTable.hours - 5]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.performSegue(withIdentifier: "SellectingDaySegue", sender: nil)
            } else if (indexPath.row == 1) {
                self.performSegue(withIdentifier: "SellectingPeriodSegue", sender: nil)
            }
        }
    }
    
}
