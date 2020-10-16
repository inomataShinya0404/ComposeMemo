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

class MemoViewController: UIViewController,UITextFieldDelegate,MPMediaPickerControllerDelegate, UITableViewDelegate,UITableViewDataSource {
    
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
        
        memoTable.delegate = self
        memoTable.dataSource = self
        
        titleArray = saveData.object(forKey: "title") as! [String]
        nameArray = saveData.object(forKey: "name") as! [String]
//ラベルに表示させないといけないよ
        print("ラベルを表示しました")

//音源をdocumentDirectoryか読み込む
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentPath.appendingPathComponent(" ")
        if FileManager.default.fileExists(atPath: url.path) {
            do {
//                player = try AVAudioPlayer(contentsOf: url)
//                guard let player = AVAudioPlayer else { return }
                print("読み込み成功")
            } catch {
                print("読み込み失敗")
            }
        } else {
            print("file not found")
        }
        
        player = MPMusicPlayerController.applicationMusicPlayer
        query = MPMediaQuery.songs()
        player.setQueue(with: query)
//リピートの有効化(１曲をリピート)
        player.repeatMode = .one
//再生バーの初期化
        slider.value = 0.0
        
        self.memoTable.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
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
        time = Timer.scheduledTimer(timeInterval: 1,
                                    target: self,
                                    selector: #selector(updateSlider),
                                    userInfo: nil,
                                    repeats: true)
        //再生時間をラベルに表示させる
        time = Timer.scheduledTimer(timeInterval: 1,
                                    target: self,
                                    selector: #selector(updateTimeLabel),
                                    userInfo: nil,
                                    repeats: true)
    }
    
    @objc func updateSlider(){
        self.slider.setValue(Float(self.player.currentPlaybackTime), animated: true)
    }
    
    @IBAction func sliderAction(){
        player.currentPlaybackTime = TimeInterval(slider.value)
        currentTime = player.currentPlaybackTime
    }
    
    @objc func updateTimeLabel() {
        currentTime = currentTime + 1
        timerLabel.text = String(format: "%", currentTime)
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
            self.memoArray.append(alertTextField!.text!)
            print("OKボタンが押されました")
        }))
        present(memoAlert, animated: true)
        
//        再生時間(currentTime)を配列に記録
//        timeArray.append(currentTime!)
        
        saveData.set(memoArray, forKey: "memo")
        
//        メモ欄にメモを表示する
        if saveData.object(forKey: "memo") != nil{
            
        }
        memoTable.reloadData()
    }
    
    @IBAction func back() {
        currentTime = player.currentPlaybackTime
        time.invalidate()
        player.pause()
        playorpause = 0
        print("曲を停止")
        
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
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
