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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        table.dataSource = self
        table.delegate = self
        
        self.table.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
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
        self.performSegue(withIdentifier: "toMemo", sender: nil)
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

//    cellをスライドで削除
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        self.titleArray.remove(at: indexPath.row)
//        self.nameArray.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
    
/*  cellを追加するメソッド
    @IBAction func addTableViewCell() {
        //新たに追加するセルを配列に格納する
        let cell : SongTableViewCell = SongTableViewCell.initFromNib()
        cell.titleLabel?.text = "\(self.cellArray.count + 1).新しい項目"
        self.cellArray.add(cell)
                
        // テーブルビューをリロードする
        self.table.reloadData()
    }
*/
    
    override func viewWillAppear(_ animated: Bool) {
        //XibカスタムCellのLabelに持ってきた値を表示する
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "title") != nil {
            titleArray = saveData.object(forKey: "title") as! [String]
            nameArray = saveData.object(forKey: "name") as! [String]
        }
        self.table.reloadData()
    }
}

