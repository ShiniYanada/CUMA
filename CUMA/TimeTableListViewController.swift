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
    var items = ["test1", "test2"]
    var selectedIndexPath: IndexPath?
    var timeTables: [TimeTable]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = editButtonItem
        let realm = try! Realm()
        let timeTables = realm.objects(TimeTable.self).sorted(byKeyPath: "createdAt")
        self.timeTables = Array(timeTables)
    }
    //navigationBarのEditボタンを押した時にtableViewの編集モードをON/OFFにする
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        if !editing {
            if let selectedIndexPath = selectedIndexPath {
                tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        let fileName = URL(string: file)!.lastPathComponent
        NSLog("\(fileName) #\(line) \(function): \(message)")
    }

}

extension TimeTableListViewController: UITableViewDelegate {
    // 編集モードの時のCellの左側にInsertion/Delete/Noneのいずれかを表示
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            if timeTables.count == 1 {
                return .none
            } else {
                return .delete
            }
        }
        return .none
    }
    // Cellの削除ボタンがを押された時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if timeTables.count != 1 {
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
    
    // Cellタップ後の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
    // Tells the delegate that a specified row is about to be selected.
    // 返り値でこれから選択されるSection/Rowを指定する。
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRow = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedRow)
            cell?.accessoryType = .none
        }
        return indexPath
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
        cell.selectionStyle = .none
        if timeTable.selected {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    // 編集モードでCellの並び替えを可能にするかどうか
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // falseの場合Insertion/Deleteの記号が表示されない。trueの場合Insertion/Deleteができるようになる
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //並び替え実行時に処理されるこの関数を実装しないとCellの右側に記号が表示されない
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let timeTable = timeTables[sourceIndexPath.row]
        timeTables.remove(at:sourceIndexPath.row)
        timeTables.insert(timeTable, at: destinationIndexPath.row)
        tableView.reloadData()
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
}
