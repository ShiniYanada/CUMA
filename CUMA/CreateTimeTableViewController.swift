//
//  CreateTimeTableViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/04.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import UIKit

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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createTimeTable(_ sender: UIBarButtonItem) {
        print("create")
    }
    
}

extension CreateTimeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! InputTableViewCell
        cell.inputTextField.becomeFirstResponder()
    }
}

extension CreateTimeTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return titles.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
        inputCell.titleLabel?.text = titles[section][row]
        inputCell.inputTextField.placeholder = placeholders[section][row]
        if section == 1 {
            inputCell.changeKeyboardTypeToPickerView(pickerData: pickerDataList[row])
        }
        return inputCell
    }
}
