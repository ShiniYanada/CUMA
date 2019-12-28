//
//  TimeTableSettingDayItemViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/12/09.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit

class TimeTableSettingDayItemViewController: UIViewController {
    
    let dayItems = ["平日のみ", "平日+土", "平日+土日"]
    var dayIndex: Int!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
}

extension TimeTableSettingDayItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    // 他のcellを選択する前に現在選択されているcellのaccessoryTypeをnoneにする
    // tableViewのllowsMultipleSelectionをtrueにしているのならばdeselectRow()を呼ばないと選択状態を解除できない
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRow = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedRow)
            cell?.accessoryType = .none
        }
        return indexPath
    }
}

extension TimeTableSettingDayItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayItemCell", for: indexPath)
        cell.textLabel?.text = dayItems[indexPath.row]
        cell.selectionStyle = .none
        // 現在のデータに該当するcellをselectRow()で選択状態にする
        if (indexPath.row == dayIndex) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension TimeTableSettingDayItemViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (viewController is TimeTableSettingViewController) {
            let index = tableView.indexPathForSelectedRow?.row
            let timeTableSettingViewController = viewController as! TimeTableSettingViewController
            timeTableSettingViewController.timeTableDayIndex = index
            timeTableSettingViewController.tableView.reloadData()
        }
    }
}
