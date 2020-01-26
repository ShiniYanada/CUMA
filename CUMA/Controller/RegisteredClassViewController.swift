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
        
        let closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        closeKeyboardTap.cancelsTouchesInView = false
        closeKeyboardTap.delegate = self
        view.addGestureRecognizer(closeKeyboardTap)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
}

extension RegisteredClassViewController: UIGestureRecognizerDelegate {
    // tap Gestureを受け取るかどうかの真偽値を返す
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if tableView.indexPathForRow(at: touch.location(in: tableView)) != nil {
            return false
        }
        return true
    }
}


extension RegisteredClassViewController: UITableViewDelegate {
    
}

extension RegisteredClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "授業名"
            cell.inputTextField.text = lesson.course
        case 1:
            cell.titleLabel.text = "担当員"
            cell.inputTextField.text = lesson.teacher
        case 2:
            cell.titleLabel.text = "教室"
            cell.inputTextField.text = lesson.room
        case 3:
            cell.titleLabel.text = "単位数"
            cell.inputTextField.text = String(lesson.credits)
        default:
            cell.titleLabel.text = ""
            cell.inputTextField.text = ""
        }
        
        return cell
    }
    
    
}
