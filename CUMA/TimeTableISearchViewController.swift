//
//  TimeTableSearchViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/26.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit
import InstantSearchClient

class TimeTableSearchViewController: UIViewController {
    
    var searchController:  UISearchController!
    @IBOutlet weak var tableView: UITableView!
    var client: Client!
    var index: Index!
    
    private let titles = [
        "row1",  "row2",  "row3",  "row4",  "row5",
        "row6",  "row7",  "row8",  "row9",  "row10",
        "row11", "row12", "row13", "row14", "row15",
        "row16", "row17", "row18", "row19", "row20",
        "row21", "row22", "row23", "row24", "row25",
        "row26", "row27", "row28", "row29", "row30"
    ]

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
        
        client = Client(appID: "J7JWGV6TIF", apiKey: "b3750fec1bafdbd445f4a15c1c1d7364")
        index = client.index(withName: "syllabus")
        
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

extension TimeTableSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        print(text)
    }
}

extension TimeTableSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classCell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        return classCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension TimeTableSearchViewController: UITableViewDelegate {
    
}
