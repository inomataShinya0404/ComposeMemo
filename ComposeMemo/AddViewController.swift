//
//  AddViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

//新しく曲を追加する画面

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    //上記データをまとめる配列
    var saveArray = [String]()
    var titleArray = [String]()
    var nameArray = [String]()
    
    //配列を保存するUserDefaults
    var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        デリゲートの所在
        titleField.delegate = self
        nameField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //TextFieldと読み込んだ音源を配列にブチ込む
    @IBAction func saveButton() {
//        saveArray.append(titleField.text!)
//        saveArray.append(nameField.text!)
        titleArray.append(titleField.text!)
        nameArray.append(nameField.text!)
        
        saveData.set(titleArray, forKey: "title")
        saveData.set(nameArray, forKey: "name")
        
//        <------ アラート ------>
        //Save完了のアラートを出してやる
        let aleart: UIAlertController = UIAlertController(title: "保存", message: "メモの保存が完了しました。", preferredStyle: .alert)
        //アラートのOKボタン
        aleart.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in
                //ボタンが押された時の動作
                self.navigationController?.popViewController(animated: true)
                print("OKボタンが押されました")
        }
            ))
        present(aleart, animated: true, completion: nil)
    }
    
    //ViewControllerに戻る
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
