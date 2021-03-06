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
    let hourItems = ["4", "5", "6", "7"]
    var timeTableName: String?
    var timeTableDayIndex: Int?
    var timeTableHourIndex: Int?
    var timeTable: TimeTable!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        timeTable = realm.objects(TimeTable.self).filter("selected == true").first
        
        let closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        // このプロパティがtrueだとcloseKeyboardTapのgestureのみが処理されcellのタップ処理などが実行されなくなる
        closeKeyboardTap.cancelsTouchesInView = false
        closeKeyboardTap.delegate = self
        view.addGestureRecognizer(closeKeyboardTap)
        
        // //textFieldのtextに変化があった時に通知する処理の登録
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(textFieldDidChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textFieldDidChanged(_ sender: Notification) {
        let textField = sender.object as! UITextField
        if let text = textField.text {
            timeTableName = text
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let inputCell = tableView.visibleCells[0] as! InputTableViewCell
        let timeTableViewController = navigationController?.viewControllers[0] as! TimeTableViewController
        
        try! realm.write {
            self.timeTable.name = inputCell.inputTextField.text ?? "時間割"
            self.timeTable.day = (self.timeTableDayIndex != nil) ? self.timeTableDayIndex! + 5 : self.timeTable.day
            self.timeTable.hour = (timeTableHourIndex != nil) ? self.timeTableHourIndex! + 4 : self.timeTable.hour
        }
        //設定した内容に時間割を再表示させる
        timeTableViewController.changeTimeTable()
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SellectingDaySegue") {
            let timeTableSettingDayItemViewController: TimeTableSettingDayItemViewController = segue.destination as! TimeTableSettingDayItemViewController
            timeTableSettingDayItemViewController.navigationItem.title = "曜日の変更"
            // dayItemsのIndexを送る
            timeTableSettingDayItemViewController.dayIndex = timeTableDayIndex ?? timeTable.day - 5
        } else if (segue.identifier == "SellectingPeriodSegue") {
            let timeTableSettingPeriodItemViewController: TimeTableSettingHourItemViewController = segue.destination as! TimeTableSettingHourItemViewController
            timeTableSettingPeriodItemViewController.navigationItem.title = "最大時限数"
            // hourItemsのIndexを送る
            timeTableSettingPeriodItemViewController.hourIndex = timeTableHourIndex ?? timeTable.hour - 4
        }
    }
}

extension TimeTableSettingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let indexPath = tableView.indexPathForRow(at: touch.location(in: tableView)) {
            if indexPath.section == 0 {
                return false
            }
        }
        return true
    }
}

extension TimeTableSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.performSegue(withIdentifier: "SellectingDaySegue", sender: nil)
            } else if (indexPath.row == 1) {
                self.performSegue(withIdentifier: "SellectingPeriodSegue", sender: nil)
            }
        } else {
            let inputCell = tableView.cellForRow(at: indexPath) as! InputTableViewCell
            inputCell.inputTextField.becomeFirstResponder()
        }
    }
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
        if (indexPath.section == 0) {
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
            inputCell.delegate = self
            inputCell.titleLabel.text = settingTitles[indexPath.section][indexPath.row]
            inputCell.inputTextField.text = timeTableName ?? timeTable.name
            return inputCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableSettingCell", for: indexPath)
            cell.textLabel?.text = self.settingTitles[indexPath.section][indexPath.row]
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = dayItems[timeTableDayIndex ?? timeTable.day - 5]
            default:
                cell.detailTextLabel?.text = hourItems[timeTableHourIndex ?? timeTable.hour - 4]
            }
            return cell
        }
    }
}

extension TimeTableSettingViewController: InputTableViewCellDelegate {
    func pressReturn(_ textField: UITextField) {
        if let text = textField.text {
            timeTableName = text
        }
        textField.resignFirstResponder()
    }
}
