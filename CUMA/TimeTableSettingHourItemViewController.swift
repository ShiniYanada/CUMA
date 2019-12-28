//
//  TimeTableSettingHourItemViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/12/09.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit

class TimeTableSettingHourItemViewController: UIViewController {

    let hourItems = ["4", "5", "6", "7"]
    var hourIndex: Int!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension TimeTableSettingHourItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRow = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedRow)
            cell?.accessoryType = .none
        }
        return indexPath
    }
}

extension TimeTableSettingHourItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeriodItemCell", for: indexPath)
        cell.textLabel?.text = hourItems[indexPath.row]
        cell.selectionStyle = .none
        if (indexPath.row == hourIndex) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension TimeTableSettingHourItemViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (viewController is TimeTableSettingViewController) {
            let index = tableView.indexPathForSelectedRow?.row
            let timeTableSettingViewController = viewController as! TimeTableSettingViewController
            timeTableSettingViewController.timeTableHourIndex = index
            timeTableSettingViewController.tableView.reloadData()
        }
    }
}
