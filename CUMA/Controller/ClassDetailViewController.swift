//
//  ClassDetailViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/11/01.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//
//授業の詳細のView

import UIKit

class ClassDetailViewController: UIViewController {
    
    var lesson: Lesson!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        print(lesson.teacher)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClassDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassInfo", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "年度"
            cell.detailTextLabel?.text = lesson.year
        case 1:
            cell.textLabel?.text = "学期"
            cell.detailTextLabel?.text = lesson.semester
        case 2:
            cell.textLabel?.text = "ターム"
            cell.detailTextLabel?.text = lesson.term.joined(separator: "・")
        case 3:
            cell.textLabel?.text = "曜日・時限"
            cell.detailTextLabel?.text = lesson.day_and_period.joined(separator: "・")
        case 4:
            cell.textLabel?.text = "年次"
            cell.detailTextLabel?.text = lesson.student_year.joined(separator: "・")
        case 5:
            cell.textLabel?.text = "授業名"
            cell.detailTextLabel?.text = lesson.course
        case 6:
            cell.textLabel?.text = "担当員"
            cell.detailTextLabel?.text = lesson.teacher
        case 7:
            cell.textLabel?.text = "教室"
            cell.detailTextLabel?.text = lesson.room
        case 8:
            cell.textLabel?.text = "単位数"
            cell.detailTextLabel?.text = lesson.credits
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
}

extension ClassDetailViewController: UITableViewDelegate {
    
}
