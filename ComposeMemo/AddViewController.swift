//
//  AddViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

//新しく曲を追加する画面

/*
 タスク
 ・選曲できたらEdit画面でジャケットとかのプレビューでわかりやすくしたい
 
 */

import UIKit
import MediaPlayer

class AddViewController: UIViewController, UITextFieldDelegate, MPMediaPickerControllerDelegate{

    @IBOutlet var titleField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    //上記データをまとめる配列
    var titleArray = [String]()
    var nameArray = [String]()
    var songArray = [String]()
    
    var picker: MPMusicPlayerController!

    //配列を保存するUserDefaults
    var saveData: UserDefaults = UserDefaults.standard
            
    override func viewDidLoad() {
        super.viewDidLoad()

//        デリゲートの所在
        titleField.delegate = self
        nameField.delegate = self
        
        picker = MPMusicPlayerController.applicationMusicPlayer
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction  func selectMusic() {
        print("音源の選択を開始")
//        インスタンスを生成
        let selecter = MPMediaPickerController()
//        デリゲートの所在
        selecter.delegate = self
//        音源の複数選択を無効にする
        selecter.allowsPickingMultipleItems = false
//        セレクターを表示する
        present(selecter, animated: true, completion: nil)
    }
    
//        曲の選択が完了されたときのメソッド
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        picker.setQueue(with: mediaItemCollection)
        print("曲が選択されました")
        
//        add : 複数曲の選択を不可にしたい
//        add : 曲の選択が終わったらボタンの文字を「選択しました」に変更したい
        
//        選択した曲をディレクトリファイルに突っ込む
        do{
            let fileManager = FileManager.default
            let docs = try fileManager.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false)
            let path = docs.appendingPathComponent("picked.mp3")
            let data = "Hello, world!".data(using: .utf8)!
            
            fileManager.createFile(atPath: path.path,
                                   contents: data, attributes: nil)
            print("ディレクトリに追加が完了")
        } catch {
            print(error)
        }
        
//        曲のデータ型をsongArrayに突っ込む
        
        dismiss(animated: true, completion: nil)

}
    
//    曲の選択がキャンセルされたときのメソッド
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        //pickerを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    //ここ謎
    func getURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("selected.m4a")
        return url
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
//        var mp3data = picker.
        
        titleArray.append(titleField.text!)
        nameArray.append(nameField.text!)
        
        saveData.set(titleArray, forKey: "title")
        saveData.set(nameArray, forKey: "name")
        
//        <------ アラート ------>
        //Save完了のアラートを出してやる
        let aleart: UIAlertController = UIAlertController(title: "保存",
                                                          message: "メモの保存が完了しました。",
                                                          preferredStyle: .alert)
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
