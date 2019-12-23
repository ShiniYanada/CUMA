//
//  TimeTableSettingHourItemViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/12/09.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit

class TimeTableSettingHourItemViewController: UIViewController {

    let hourItem = ["5", "6", "7", "8", "9", "10"]
    var hourIndex: Int!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeriodItemCell", for: indexPath)
        cell.textLabel?.text = hourItem[indexPath.row]
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
