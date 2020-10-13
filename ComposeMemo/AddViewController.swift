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

class AddViewController: UIViewController, UITextFieldDelegate, MPMediaPickerControllerDelegate{

    //UI
    @IBOutlet var titleField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    //上記データをまとめる配列
    var titleArray: Array = [String]()
    var nameArray: Array = [String]()
    var songArray: Array = [String]()

    var player: MPMusicPlayerController!

    //配列を保存するUserDefaults
    var saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self
        nameField.delegate = self
        
        let selecter = MPMediaPickerController()
        selecter.delegate = self
        selecter.allowsPickingMultipleItems = false
        present(selecter, animated: true, completion: nil)
    }
    
    @IBAction  func selectMusic() {
        print("音源の選択を開始")
        let selecter = MPMediaPickerController()
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
        
//選択した曲をディレクトリファイルに突っ込む
        let fileManager = FileManager.default
        let documentURL = try! fileManager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true)
        let outputURL = documentURL.appendingPathComponent("picked.m4a")
        do{
            try FileManager.default.removeItem(at: outputURL)
            print("removed")
        } catch let error as NSError {
            print(error)
        }
//曲のデータ型をsongArrayに突っ込む
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
        
        let aleart = UIAlertController(title: "保存",message: "メモの保存が完了しました。",preferredStyle: .alert)
        aleart.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                print("OKボタンが押されました")
        }))
        present(aleart, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    曲の情報を表示するメソッド
    func updateInformationUI(mediaItem: MPMediaItem){
        titleLabel.text = mediaItem.albumTitle
        artistLabel.text = mediaItem.albumArtist
        
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
