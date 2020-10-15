//
//  AddViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

//新しく曲を追加する画面
/*
 【タスク】
 ・選曲 -> DocumentDirectlyに保存 -> ID的な何か
 */

import UIKit
import MediaPlayer

var titleArray: Array = [String]()
var nameArray: Array = [String]()
var songArray: Array = [String]()

var saveData: UserDefaults = UserDefaults.standard

var selecter = MPMediaPickerController()

let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let url = documentsPath.appendingPathComponent("SelectedMusic.m4a")

class AddViewController: UIViewController, UITextFieldDelegate, MPMediaPickerControllerDelegate{

    @IBOutlet var titleField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var artworkImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!

    var player: MPMusicPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let selecter = MPMediaPickerController()
        selecter.delegate = self
        selecter.allowsPickingMultipleItems = false
        present(selecter, animated: true, completion: nil)
        
        titleField.delegate = self
        nameField.delegate = self
    }
    
    @IBAction  func selectMusic() {
        print("音源の選択を開始")
        selecter.delegate = self
        selecter.allowsPickingMultipleItems = false
        present(selecter, animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player = MPMusicPlayerController.applicationMusicPlayer
        player.stop()
        player.setQueue(with: mediaItemCollection)
        print("曲が選択されました")
        dismiss(animated: true, completion: nil)
        
        if let mediaItem = mediaItemCollection.items.first {
            updateInformationUI(mediaItem: mediaItem)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
    
//URLを取得する(ここ謎)
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

    @IBAction func saveButton() {
        titleArray.append(titleField.text!)
        nameArray.append(nameField.text!)
        
        saveData.set(titleArray, forKey: "title")
        saveData.set(nameArray, forKey: "name")
        
        if selecter == nil {
            let selectMusicAlerat = UIAlertController(title: "音源が選択されていません",
                                                      message: "選択ボタンをタップして音源を選択してください。",
                                                      preferredStyle: .alert)
            selectMusicAlerat.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                print("選曲していません！")
            }))
            present(selectMusicAlerat, animated: true, completion: nil)
        }
        
        let aleart = UIAlertController(title: "保存",message: "音源の保存が完了しました。",preferredStyle: .alert)
        aleart.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                print("OKボタンが押されました")
        }))
        present(aleart, animated: true, completion: nil)
        
//選択した曲をディレクトリファイルに突っ込む
        do {
            let data:[UInt8] = ""
            try Data(bytes: data, count: data.count).write(to: documentsPath)
          print("書き込み成功")
        } catch let error {
          print(error.localizedDescription)
          print("書き込み失敗")
        }
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateInformationUI(mediaItem: MPMediaItem){
        titleField.text = mediaItem.albumTitle
        nameField.text = mediaItem.albumArtist
        
        if let artwork = mediaItem.artwork {
                let image = artwork.image(at: artworkImageView.bounds.size)
                artworkImageView.image = image
        } else {
                artworkImageView.image = nil
                artworkImageView.backgroundColor = UIColor.gray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
