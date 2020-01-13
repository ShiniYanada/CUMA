//
//  TimeTableListViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/11/11.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//
// 作成している時間割の一覧を表示するView

import UIKit
import RealmSwift

class TimeTableListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // Results型からArrayに変換したrealmデータの配列
    var timeTables: Results<TimeTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        // 時間割の新規作成機能を追加する。
        let realm = try! Realm()
        let timeTables = realm.objects(TimeTable.self).sorted(byKeyPath: "createdAt")
        self.timeTables = timeTables
    }
    
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        let fileName = URL(string: file)!.lastPathComponent
        NSLog("\(fileName) #\(line) \(function): \(message)")
    }
}

extension TimeTableListViewController: UITableViewDelegate {
    // 編集モードの時のCellの左側にInsertion/Delete/Noneのいずれかを表示
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if timeTables.count == 1 {
            return .none
        } else {
            return .delete
        }
    }
    // Cellの削除ボタンがを押された時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if timeTables.count == 1 {
            print("timeTable is one")
            return
        }
        if editingStyle == .delete {
            let realm = try! Realm()
            let isCurrent = timeTables[indexPath.row].selected
            try! realm.write {
                realm.delete(timeTables[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            //　現在設定している時間割を削除した場合最初に見つかった時間割を表示させる
            if isCurrent {
                let timeTable = realm.objects(TimeTable.self).first
                try! realm.write {
                    timeTable!.selected = true
                }
                let tabVC = presentingViewController as! UITabBarController
                let navigationVC = tabVC.selectedViewController as! UINavigationController
                let timeTableVC = navigationVC.topViewController as! TimeTableViewController
                timeTableVC.changeTimeTable()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Cellタップ後の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeTable = timeTables[indexPath.row]
        if timeTable.selected {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let realm = try! Realm()
        let currentTimeTable = realm.objects(TimeTable.self).filter("selected == true").first
        try! realm.write {
            currentTimeTable?.selected = false
            timeTable.selected = true
        }
        
        let tabVC = presentingViewController as! UITabBarController
        let navigationVC = tabVC.selectedViewController as! UINavigationController
        let timeTableVC = navigationVC.topViewController as! TimeTableViewController
        timeTableVC.changeTimeTable()
        dismiss(animated: true, completion: nil)
    }
}

extension TimeTableListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let timeTable = timeTables[indexPath.row]
        cell.textLabel?.text = timeTable.name
        if timeTable.selected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    // falseの場合Insertion/Deleteの記号が表示されない。trueの場合Insertion/Deleteができるようになる
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // isEditing = falseの時、セルをスワイプさせて削除しようとすると、
    // まず、tableView(_:canEditRowAt:)を確認してtrueならtableView(_:editingStyleForRowAt:)を確認する。
    //ここでは、tableView(_:editingStyleForRowAt:)はisEditing=falseの時
    // .noneとなっているのでスワイプ削除できない。
    
    // Editボタンを押すと、setEditing(_:animated:)が呼ばれて、isEditing = trueの処理を加える。
    // まず、tableView(_:canEditRowAt:)を確認して trueの場合に並び替えやInsertion、Deleteができる。
    // 次に、tableView(_:editingStyleForRowAt:)でInsertion、Delete、Noneのいずれかにする処理をする
    // 次に、tableView(_:shouldIndentWhileEditingRowAt:)が呼ばれる。
    // 最後に、tableView(_:canMoveRowAt:)が呼ばれる。
    
    // スワイプで削除しようとするときに毎回tableView(_:editingStyleForRowAt:)が呼ばれ
    // .deleteや.noneなどを判断する。
}
