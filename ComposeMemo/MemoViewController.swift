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
 */

import UIKit
import MediaPlayer
import AVFoundation

class MemoViewController: UIViewController,UITextFieldDelegate,MPMediaPickerControllerDelegate, UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate{
    
    @IBOutlet var artwork: UIImageView!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet var playAndPauseButton: UIButton!
    
    @IBOutlet var memoTable: UITableView!
    
    var receiveIndexPath = Int()
    
    //この画面の操作から要素を入れられる配列
    var memoArray:Array = [String]()
    var timeArray:Array = [Timer]()
    
    var audioplayer: AVAudioPlayer!

//    var player: MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer
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
                
        if UserDefaults.standard.object(forKey: "title") != nil {
            titleArray = saveData.object(forKey: "title") as! [String]
            titleLabel.text = titleArray[receiveIndexPath]
        }
        
        if UserDefaults.standard.object(forKey: "name") != nil {
            nameArray = saveData.object(forKey: "name") as! [String]
            artistLabel.text = nameArray[receiveIndexPath]
        }
        print("ラベルを表示しました")
        
        if saveData.object(forKey: "path") != nil {
            pathArray = saveData.object(forKey: "path") as! [String]
            print("パス配列の中身は\(pathArray)だよ〜")
            print(receiveIndexPath)
            
            let receiveURL: String = pathArray[receiveIndexPath]
            print("\(receiveURL)")
/*
            var encodedString: String = receiveURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            var openURL = URL(string: encodedString)
            print("openURL is \(openURL)")

            print("load \(openURL)")
            var audioplayer = AVAudioPlayer()

            do {
                audioplayer = try AVAudioPlayer(contentsOf: openURL!)
                audioplayer.prepareToPlay()
                audioplayer.play()
            } catch let error as Error {
                audioplayer == nil
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
 */
            if let audioUrl = URL(string: receiveURL) {
                let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory,
                                                                   in: .userDomainMask).first!
                let destinationURL = documentDirectoryUrl.appendingPathComponent(audioUrl.lastPathComponent)
                
                print(destinationURL)
                do {
//                    audioplayer.delegate = self
                    self.audioplayer = try AVAudioPlayer(contentsOf: audioUrl)
                    audioplayer.prepareToPlay()
                    audioplayer.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
//        player.repeatMode = .one
        slider.value = 0.0
        
        self.memoTable.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func play() {
        if playorpause == 0 {
//            player.currentPlaybackTime = currentTime
//            player.play()
            
            audioplayer?.play()
            
            playorpause = 1
            print("曲を再生")
            playAndPauseButton.setImage(UIImage(named: "再生ボタン.png"), for: UIControl.State())
        } else {
//            currentTime = player.currentPlaybackTime
            time.invalidate()
//            player.pause()
            
            audioplayer?.stop()
            
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
//        self.slider.setValue(Float(self.player.currentPlaybackTime), animated: true)
    }
    
    @IBAction func sliderAction(){
//        player.currentPlaybackTime = TimeInterval(slider.value)
//        currentTime = player.currentPlaybackTime
    }
    
    @objc func updateTimeLabel() {
        currentTime = currentTime + 1
        timerLabel.text = String(format: "%", currentTime)
    }

    @IBAction func memo() {
        print("memoボタンが押されました")
//        currentTime = player.currentPlaybackTime
//        player.pause()
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
            self.memoArray.append(alertTextField.text!)
            print("OKボタンが押されました")
        }))
        present(memoAlert, animated: true)
        
//        再生時間(currentTime)を配列に記録
//        timeArray.append(currentTime!)
        
        saveData.set(memoArray, forKey: "memo")
        
        if saveData.object(forKey: "memo") != nil{
        
        }
        memoTable.reloadData()
    }
    
    @IBAction func back() {
//        currentTime = player.currentPlaybackTime
        time.invalidate()
//        player.pause()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ audioplayer: AVAudioPlayer, error: Error?) {
            print("デコードエラー")
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
