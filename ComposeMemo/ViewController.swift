//
//  ViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/09/30.
//  Copyright © 2020 Shinya . All rights reserved.
//

//曲のリストを表示する画面

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!
    
//    曲のデータを入れる配列
    var songArray = [String]()
    var titleArray = [String]()
    var nameArray = [String]()
    
//    配列を保存するuserDefaults
    var defaults:UserDefaults = UserDefaults.standard
    
    //tableView表示のテスト要素
    let testItem = ["あいみょん","WANIMA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        table.dataSource = self
        table.delegate = self
        
//        tableViewCellの高さを定義
        self.table.estimatedRowHeight = 70
        
        self.table.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return songArray.count
        return titleArray.count
    }
    
//    tableViewCellにsongArrayの内容を表示してやる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! SongTableViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        
        return cell
    }
  
//    tableViewCellの高さを定義
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70.0
//    }

//    tableViewCellをスライドで削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.songArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //XibカスタムCellのLabelに持ってきた値を表示する
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "title") != nil {
            songArray = UserDefaults.standard.object(forKey: "title") as! [String]
        }
        //tableViewをリロードする
        self.table.reloadData()
    }
}

