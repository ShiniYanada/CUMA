//
//  TimeTableSearchViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/26.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//
//指定された曜日、時限の時間割を検索して表示するView

import UIKit
import InstantSearchClient
import SwiftyJSON

class TimeTableSearchViewController: UIViewController {
    
    var searchController:  UISearchController!
    @IBOutlet weak var tableView: UITableView!
    
    var classes: [Lesson] = []
    let client = Client(appID: "J7JWGV6TIF", apiKey: "b3750fec1bafdbd445f4a15c1c1d7364")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ClassCell", bundle: nil), forCellReuseIdentifier: "ClassCell")
            
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "授業名や担当員を検索"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // iOS11未満は別途処理が必要
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        let index = client.index(withName: "syllabus")
        let query = Query(query: "")
        query.filters = ("year:2019 AND semester:後期 AND day_and_period:月6")
        index.search(query, completionHandler: { (res, error) in
            let json = JSON(res!["hits"]!)
            for (_, classInfo): (String, JSON) in json {
                let term = classInfo["term"].arrayValue.map { $0.stringValue }
                let day_and_period = classInfo["day_and_period"].arrayValue.map { $0.stringValue }
                let student_year = classInfo["student_year"].arrayValue.map { $0.stringValue }
                let lesson: Lesson = Lesson(year: classInfo["year"].stringValue, semester: classInfo["semester"].stringValue, term: term, day_and_period: day_and_period, student_year: student_year, course: classInfo["course"].stringValue, teacher: classInfo["teacher"].stringValue, room: classInfo["room"].stringValue, credits: classInfo["credits"].stringValue)
                self.classes.append(lesson)
            }
            self.tableView.reloadData()
        })
    }
    
    @objc func registerClass(_ sender: UIButton) {
        print("tapped")
        print(sender.tag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "ClassDetailSegue" {
            let classDetailViewController: ClassDetailViewController = segue.destination as! ClassDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            print(indexPath!.row)
            print(classes[indexPath!.row])
            classDetailViewController.lesson = classes[indexPath!.row]
        }
    }

}

extension TimeTableSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        print(text)
    }
}

extension TimeTableSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classCell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassCell
        classCell.setup(lesson: self.classes[indexPath.row])
        classCell.registerClassBtn.tag = indexPath.row
        classCell.registerClassBtn.addTarget(self, action: #selector(registerClass(_:)), for: .touchUpInside)
        return classCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension TimeTableSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ClassDetailSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
