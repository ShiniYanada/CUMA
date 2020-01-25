//
//  CreateTimeTableViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/04.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import UIKit
import RealmSwift

class CreateTimeTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var titles = [["名称"], ["時限", "曜日"]]
    var placeholders = [["時間割の名称"], ["最大時限数", "曜日"]]
    let pickerDataList = [["4", "5", "6", "7"], ["平日のみ", "平日+土", "平日+土日"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        tableView.register(UINib(nibName: "InputPickerViewCell", bundle: nil), forCellReuseIdentifier: "InputPickerCell")
        tableView.keyboardDismissMode = .interactive
        navigationItem.rightBarButtonItem?.isEnabled = false

        let closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        // このプロパティがtrueだとcloseKeyboardTapのgestureのみが処理されcellのタップ処理などが実行されなくなる
        closeKeyboardTap.cancelsTouchesInView = false
        closeKeyboardTap.delegate = self
        view.addGestureRecognizer(closeKeyboardTap)
        
        let center = NotificationCenter.default
        //textFieldのtextに変化があった時に通知する
        center.addObserver(self, selector: #selector(textFieldDidChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    // textFieldに文字がない場合、作成ボタンを無効にし文字がある場合は有効にする
    @objc func textFieldDidChanged(_ sender: Notification) {
        let textField = sender.object as! UITextField
        if let text = textField.text {
            navigationItem.rightBarButtonItem?.isEnabled = (text != "")
        }
    }
    
    // 作成ボタンを押し、realmにデータを保存する
    @IBAction func createTimeTable(_ sender: UIBarButtonItem) {
        let nameCell = tableView.visibleCells[0] as! InputTableViewCell
        let hourCell = tableView.visibleCells[1] as! InputPickerViewCell
        let dayCell = tableView.visibleCells[2] as! InputPickerViewCell
        let name = nameCell.inputTextField.text!
        let hourText = hourCell.inputTextField.text!
        let dayText = dayCell.inputTextField.text!
        var realm: Realm!
        
        // 曜日と時限のデータがpickerViewにあるデータ以外だった場合の処理
        if !pickerDataList[0].contains(hourText) || !pickerDataList[1].contains(dayText) {
            print("day or hour is invalid")
            return
        }
        let hour = Int(hourText)!
        let day = pickerDataList[1].firstIndex(of: dayText)! + 5
        // 時間割の名称が入力されていた場合にrealmに保存
        if name != "" {
            let timeTable = TimeTable(value: [name, day, hour, true])
            realm = try! Realm()
            try! realm.write {
                realm.add(timeTable)
            }
        } else {
            print("name is empty")
            return
        }
        //　表示する時間割を変える処理
        let currentTimeTable = realm.objects(TimeTable.self).filter("selected == true").first
        try! realm.write {
            currentTimeTable?.selected = false
        }
        let tabVC = presentingViewController as! UITabBarController
        let navigationVC = tabVC.selectedViewController as! UINavigationController
        let timeTableVC = navigationVC.topViewController as! TimeTableViewController
        timeTableVC.changeTimeTable()
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreateTimeTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if tableView.indexPathForRow(at: touch.location(in: tableView)) != nil {
            return false
        }
        return true
    }
}

extension CreateTimeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cell = tableView.cellForRow(at: indexPath) as! InputTableViewCell
            cell.inputTextField.becomeFirstResponder()
        case 1:
            let cell = tableView.cellForRow(at: indexPath) as! InputPickerViewCell
            cell.inputTextField.becomeFirstResponder()
        default:
            break
        }
    }
}

extension CreateTimeTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
            inputCell.delegate = self
            inputCell.titleLabel.text = titles[section][row]
            inputCell.inputTextField.placeholder = placeholders[section][row]
            return inputCell
        } else {
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputPickerCell", for: indexPath) as! InputPickerViewCell
            inputCell.titleLabel.text = titles[section][row]
            inputCell.initPickerView(pickerData: pickerDataList[row])
            return inputCell
        }
    }
}

extension CreateTimeTableViewController: InputTableViewCellDelegate {
    func pressReturn(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
