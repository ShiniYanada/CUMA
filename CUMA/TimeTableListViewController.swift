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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    //navigationBarのEditボタンを押した時にtableViewの編集モードをON/OFFにする
    override func setEditing(_ editing: Bool, animated: Bool) {
        debugLog()
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        let fileName = URL(string: file)!.lastPathComponent
        NSLog("\(fileName) #\(line) \(function): \(message)")
    }

}

extension TimeTableListViewController: UITableViewDelegate {
    // 編集モードの時のCellの左側にInsertion/Delete/Noneのいずれかを表示
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        debugLog()
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    // Cellの削除ボタンがを押された時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("delete")
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
    }
}

extension TimeTableListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        debugLog()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugLog()
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        debugLog()
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    // 編集モードでCellの並び替えを可能にするかどうか
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        debugLog()
        return true
    }
    // falseの場合Insertion/Deleteの記号が表示されない。trueの場合Insertion/Deleteができるようになる
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        debugLog()
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        debugLog()
        return false
    }
    
    //並び替え実行時に処理されるこの関数を実装しないとCellの右側に記号が表示されない
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        debugLog()
        let item = items[sourceIndexPath.row]
        items.remove(at:sourceIndexPath.row)
        items.insert(item, at: destinationIndexPath.row)
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
