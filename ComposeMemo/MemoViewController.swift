//
//  MemoViewController.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

//曲を再生してメモを加える画面

import UIKit
import MediaPlayer

class MemoViewController: UIViewController, MPMediaPickerControllerDelegate {

    @IBOutlet var slider: UISlider!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    //配列を保存するuserDefaults
    var defaults:UserDefaults = UserDefaults.standard
    var titleArray = [String]()
    var nameArray = [String]()
    
    //この画面の操作から要素を入れられる配列
    var memoArray = [String]()
    var timeArray = [Timer]()
    
    //MediaPlayerのインスタンスを作成
    var player: MPMusicPlayerController!
    var query: MPMediaQuery!
    
    //タイマー
    var time = Timer()
    
    //再生時間の長さ
    var timeInterval = TimeInterval()
    
    //再生しているか停止しているかを判別するのに使う変数
    var playorpause = 0
    //曲の再生位置の変数
    var currentTime = 0.0
    
    //メモを追加するときに使うalert
    let memoAlert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        プレイヤーの準備
        player = MPMusicPlayerController.applicationMusicPlayer
        query = MPMediaQuery.songs()
        player.setQueue(with: query)
        
//        再生バーの初期化
        slider.value = 0.0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "title") != nil {
           print("ラベルを表示するよ")
            titleArray = UserDefaults.standard.object(forKey: "title") as! [String]
            nameArray = UserDefaults.standard.object(forKey: "name") as! [String]
        }
        
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
            
        } else {
            currentTime = player.currentPlaybackTime
            time.invalidate()
            player.pause()
            playorpause = 0
            print("曲を停止")
        }
    }
    
    func updateSong(mediaItem: MPMediaItem){
//        曲の情報を表示する
        titleLabel.text = mediaItem.albumTitle
        artistLabel.text = mediaItem.albumArtist
        timeInterval = mediaItem.playbackDuration
    }
    
//    スライダーを曲の再生位置と同期させる
    func updateSlider(){
        self.slider.setValue(Float(self.player.currentPlaybackTime), animated: true)
    }
    
    @IBAction func sliderAction(){
        player.currentPlaybackTime = TimeInterval(slider.value)
        currentTime = player.currentPlaybackTime
    }
    
    @IBAction func memo() {
//        ボタンが押されたらtextField付きアラートを出してコメント欄を表示
        var alertTextField: UITextField?
        
        let memoingAlert = UIAlertController(title: "メモを入力",
                                             message: "記録したいことを書き込みましょう！",
                                             preferredStyle: UIAlertController.Style.alert)
        memoingAlert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField})
        
        //OKボタンとCancelボタンを実装
        memoingAlert.addAction(UIAlertAction(title: "Cancel",style: UIAlertAction.Style.cancel,handler: nil))
        memoingAlert.addAction(UIAlertAction(title: "OK",style: UIAlertAction.Style.default))
        present(memoAlert, animated: true, completion: nil)
        
//    アラートのOKが押されたらメモを入れておく配列に追加する
        
//        メモされた再生時間を記録
        
//        キーボードは改行で閉じれる
        
        
//        textFiledの内容を配列に入れる
        
//        再生時間(currentTime)を保存
        
//        メモ欄にメモを表示する
    }
    
    @IBAction func back() {
//        曲を止める
        
//        画面遷移を戻す
        self.dismiss(animated: true, completion: nil)
    }

}
