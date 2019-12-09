//
//  TimeTableSettingViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/12/08.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit

class TimeTableSettingViewController: UIViewController {

    let settingTitle = [["時間割名"], ["曜日", "時限"]]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SellectingDaySegue") {
            let timeTableSellectingDayItemViewController: TimeTableSettingDayItemViewController = segue.destination as! TimeTableSettingDayItemViewController
            timeTableSellectingDayItemViewController.navigationItem.title = "曜日の変更"
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
        cell.textLabel?.text = self.settingTitle[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.performSegue(withIdentifier: "SellectingDaySegue", sender: nil)
    }
    
}
