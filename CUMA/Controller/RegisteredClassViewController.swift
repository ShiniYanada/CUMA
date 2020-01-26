//
//  RegisteredClassViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/25.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import UIKit
import RealmSwift

class RegisteredClassViewController: UIViewController {
    
    var lesson: Lesson = Lesson(id: "fdaio", year: 2019, semester: "前期", term: ["jsado"], day_and_period: ["sdf"], student_year: ["fsd"], course: "fds", teacher: "treacher", room: "room", credits: 2)
    @IBOutlet weak var tableView: UITableView!
    var day: String = ""
    var hour: String = ""
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(day) \(hour)"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let timeTable = realm.objects(TimeTable.self).filter("selected == true").first!
        let lesson = timeTable.classes.filter("day == %@ && hour == %@", day, hour).first!
        self.lesson = Lesson(id: lesson.id, year: lesson.year, semester: lesson.semester, term: lesson.term.map {$0}, day_and_period: lesson.dayAndPeriod.map {$0}, student_year: lesson.studentYear.map {$0}, course: lesson.name, teacher: lesson.teacher, room: lesson.room, credits: lesson.credit)
    }
}


extension RegisteredClassViewController: UITableViewDelegate {
    
}

extension RegisteredClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "年度"
            cell.inputTextField.text = String(lesson.year)
        case 1:
            cell.titleLabel.text = "学期"
            cell.inputTextField.text = lesson.semester
        case 2:
            cell.titleLabel.text = "ターム"
            cell.inputTextField.text = lesson.term.joined(separator: "・")
        case 3:
            cell.titleLabel.text = "曜日・時限"
            cell.inputTextField.text = lesson.day_and_period.joined(separator: "・")
        case 4:
            cell.titleLabel.text = "年次"
            cell.inputTextField.text = lesson.student_year.joined(separator: "・")
        case 5:
            cell.titleLabel.text = "授業名"
            cell.inputTextField.text = lesson.course
        case 6:
            cell.titleLabel.text = "担当員"
            cell.inputTextField.text = lesson.teacher
        case 7:
            cell.titleLabel.text = "教室"
            cell.inputTextField.text = lesson.room
        case 8:
            cell.titleLabel.text = "単位数"
            cell.inputTextField.text = String(lesson.credits)
        default:
            cell.titleLabel.text = ""
            cell.inputTextField.text = ""

        }
        
        return cell
    }
    
    
}
