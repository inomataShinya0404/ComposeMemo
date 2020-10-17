//
//  ViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/09/30.
//  Copyright © 2020 Shinya . All rights reserved.
//

//曲のリストを表示する画面
/*
 【タスク】
 ・XibカスタムCellを追加で表示しないと
 */

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!
        
    var indexNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        table.dataSource = self
        table.delegate = self
        
        table.allowsMultipleSelectionDuringEditing = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.table.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "title") != nil {
            titleArray = saveData.object(forKey: "title") as! [String]
            nameArray = saveData.object(forKey: "name") as! [String]
        }
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
//    tableViewCellにArrayの内容を表示してやる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! SongTableViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.nameLabel.text = nameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cellがタップされました")
        tableView.deselectRow(at: indexPath, animated: true)
        indexNum = indexPath.row
        performSegue(withIdentifier: "toMemo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "toMemo" {
            let nextVC: MemoViewController = segue.destination as! MemoViewController
            nextVC.receiveIndexPath = indexNum
        }
    }

//    cellを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        titleArray.remove(at: indexPath.row)
        nameArray.remove(at: indexPath.row)
        pathArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
//        if tableView.isEditing {
//            return .delete
//        }
//        return .none
//    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        table.isEditing = editing
//        print(editing)
//    }
}

