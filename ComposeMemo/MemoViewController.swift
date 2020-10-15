//
//  MemoViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

//曲を再生してメモを加える画面
/*
 【タスク】
 ・音源をiPhoneのDocumentDirectlyから読み込む
 ・Memoボタンが押されたらTextField付きのアラートが出てくる
 */

import UIKit
import MediaPlayer

class MemoViewController: UIViewController,UITextFieldDelegate,MPMediaPickerControllerDelegate {

    @IBOutlet var artwork: UIImageView!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet var playAndPauseButton: UIButton!
    
    @IBOutlet var memoTable: UITableView!
    
    //この画面の操作から要素を入れられる配列
    var memoArray:Array = [String]()
    var timeArray:Array = [Timer]()
    
    //MediaPlayerのインスタンスを作成
    var player: MPMusicPlayerController!
    var query: MPMediaQuery!
    
    //タイマー
    var time = Timer()
    //再生時間の長さ
    var timeInterval = TimeInterval()
    //再生しているか停止しているかを判別するのに使う変数
    var playorpause: Int = 0
    //曲の再生位置の変数
    var currentTime: Double = 0.0
    
    //メモを追加するときに使うalert
    var memoAlert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //音源をdocumentDirectoryか読み込む
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let url = documentsURL.appendingPathComponent("SelectedMusic.m4a")
            let m4aData = try Data(contentsOf: url)
            print("読み込み成功")
        } catch {
            print("読み込み失敗")
        }
        
        titleArray = saveData.object(forKey: "title") as! [String]
        nameArray = saveData.object(forKey: "name") as! [String]
        //ラベルに表示
        print("ラベルを表示しました")
        
        if artwork.image == nil {
            artwork.image = UIImage(named: "NoImage.png")
        }

//プレイヤーの準備
        player = MPMusicPlayerController.applicationMusicPlayer
        query = MPMediaQuery.songs()
//曲をPlayerにセットする
        player.setQueue(with: query)
//リピートの有効化(１曲をリピート)
        player.repeatMode = .one
//再生バーの初期化
        slider.value = 0.0
        
        self.memoTable.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        // Do any additional setup after loading the view.
    }
    
        //曲を読み込む
        //ディレクトリを探してパスを取得
/*
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask[0])
        guard let fileName = try! FileManager.default.contentsOfDirectory(atPath: documentPath) else{
            return
        }
        return fileName.compactMap { fileName in
            guard let content = try! String(contentsOfFile: documentPath + "/" + fileName, encoding: .utf8) else {
                return nil
            }
            return content
        }
 */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func play() {
        if playorpause == 0 {
            player.currentPlaybackTime = currentTime
            player.play()
            playorpause = 1
            print("曲を再生")
            playAndPauseButton.setImage(UIImage(named: "再生ボタン.png"), for: UIControl.State())
            
        } else {
            currentTime = player.currentPlaybackTime
            time.invalidate()
            player.pause()
            playorpause = 0
            print("曲を停止")
            playAndPauseButton.setImage(UIImage(named: "一時停止ボタン.png"), for: UIControl.State())

        }
        
        //スライダーと曲を同期
        time = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                    selector: #selector(updateSlider),
                                    userInfo: nil, repeats: true)
        
        timerLabel.text = String(format: "%", time)
    }
    
// スライダーを曲の再生位置と同期させる
    @objc func updateSlider(){
        self.slider.setValue(Float(self.player.currentPlaybackTime), animated: true)
    }
    
    @IBAction func sliderAction(){
        player.currentPlaybackTime = TimeInterval(slider.value)
        currentTime = player.currentPlaybackTime
    }

    @IBAction func memo() {
        currentTime = player.currentPlaybackTime
        player.pause()
        time.invalidate()
        playorpause = 0
        
//        メモされた再生時間を取得

        var alertTextField: UITextField!
        memoAlert = UIAlertController(title: "メモ",message: "記録したい内容を入力してください。",preferredStyle: .alert)
        memoAlert.addTextField(configurationHandler:{
            (textField: UITextField!) in
            alertTextField?.delegate = self
        })
        memoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("OKボタンが押されました")
        }))
        present(memoAlert, animated: true)
        memoArray.append(alertTextField.text!)
        saveData.set(memoArray, forKey: "memo")
        
//        再生時間(currentTime)を配列に記録
//        timeArray.append(currentTime!)
        
//        メモ欄にメモを表示する
        if saveData.object(forKey: "memo") != nil{
            
        }
        memoTable.reloadData()
    }
    
    @IBAction func back() {
//      曲を止める
        currentTime = player.currentPlaybackTime
        time.invalidate()
        player.pause()
        playorpause = 0
        print("曲を停止")
        
//      画面遷移
        self.dismiss(animated: true, completion: nil)
    }

//    tableViewCellにArrayの内容を表示してやる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memoCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! MemoTableViewCell
        memoCell.memoLabel.text = memoArray[indexPath.row]
        return memoCell
    }
    
//　　　　キーボードを改行で閉じるやつ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
