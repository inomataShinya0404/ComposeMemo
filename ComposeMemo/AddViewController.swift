//
//  AddViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

//新しく曲を追加する画面

import UIKit
import MediaPlayer

var titleArray: Array = [String]()
var nameArray: Array = [String]()
var songArray: Array = [String]()
var pathArray: Array = [String]()

var saveData: UserDefaults = UserDefaults.standard

var selecter = MPMediaPickerController()

//let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//let url = documentsPath.appendingPathComponent("Select.m4a")



class AddViewController: UIViewController, UITextFieldDelegate, MPMediaPickerControllerDelegate{

    @IBOutlet var titleField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var artworkImageView: UIImageView!

    var player: MPMusicPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        player = MPMusicPlayerController.applicationMusicPlayer
//        player.stop()
//        player.setQueue(with: mediaItemCollection)
        print("曲が選択が完了")
        dismiss(animated: true, completion: nil)
        
        let item: MPMediaItem = mediaItemCollection.items[0]
        let pathURL: URL? = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        if pathURL == nil {
            return
        }
        
        let string = pathURL!.absoluteString
        let string2 = string.replacingOccurrences(of: "ipod-library://item/item", with: "")
        let arr = string2.components(separatedBy: "?")
        var mimeType = arr[0]
        mimeType = mimeType.replacingOccurrences( of: ".", with: "")
        
        let exportSession = AVAssetExportSession(asset: AVAsset(url: pathURL!),
                                                 presetName: AVAssetExportPresetAppleM4A)
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.metadata = AVAsset(url: pathURL!).metadata
        
        let song_title = item.value(forProperty: MPMediaItemPropertyTitle) as! String
        let filename_song = song_title.replacingOccurrences(of: " ", with: "_")
        
        let documentURL = try! FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        let outputURL = documentURL.appendingPathComponent("\(filename_song).m4a")
        
        print("曲のURLは\(outputURL)だよ")
        
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        exportSession?.outputURL = outputURL
        exportSession?.exportAsynchronously(completionHandler: { () -> Void in
            if (exportSession!.status == AVAssetExportSession.Status.completed) {
                print("音源のエクスポートが成功しました")
                do {
                    let newURL = outputURL.deletingPathExtension().appendingPathExtension("mp3")
                    let str = try FileManager.default.moveItem(at: outputURL, to: newURL)
                    print(str)
                } catch {
                    print("ファイルを読み込めませんでした")
                }
            } else if (exportSession!.status == AVAssetExportSession.Status.cancelled) {
                print("音源の書き出しがキャンセルされました")
            } else {
                print("音源書き出しのエラー :- ", exportSession!.error!.localizedDescription)
            }
        })
        
        var stringURL = outputURL.absoluteString
        print("stringURL is \(stringURL)")
        pathArray.append(stringURL)
        
        if let mediaItem = mediaItemCollection.items.first {
            updateInformationUI(mediaItem: mediaItem)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButton() {
        titleArray.append(titleField.text!)
        nameArray.append(nameField.text!)
        
        saveData.set(pathArray, forKey: "path")
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
}
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateInformationUI(mediaItem: MPMediaItem){
        titleField.text = mediaItem.title
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
