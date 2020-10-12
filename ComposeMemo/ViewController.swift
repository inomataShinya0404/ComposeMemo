//
//  ViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/09/30.
//  Copyright © 2020 Shinya . All rights reserved.
//

//曲のリストを表示する画面

import UIKit

//extension ViewController: SongTableViewCellDelegate {
//    func cellTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!
    
//    曲のデータを入れる配列
    var songArray = [String]()
    var titleArray = [String]()
    var nameArray = [String]()
    
//    配列を保存するuserDefaults
    var defaults:UserDefaults = UserDefaults.standard
    
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
    
//    cellをタップすると画面遷移する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cellがタップされました")
        self.performSegue(withIdentifier: "toMemo", sender: nil)
    }
  
//    tableViewCellの高さを定義
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

//    tableViewCellをスライドで削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.titleArray.remove(at: indexPath.row)
        self.nameArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //XibカスタムCellのLabelに持ってきた値を表示する
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "title") != nil {
            titleArray = UserDefaults.standard.object(forKey: "title") as! [String]
            nameArray = UserDefaults.standard.object(forKey: "name") as! [String]
        }
        //tableViewをリロードする
        self.table.reloadData()
    }
}

