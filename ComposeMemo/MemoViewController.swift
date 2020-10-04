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
    
    var titleArray = [String]()
    var nameArray = [String]()
    
    //    配列を保存するuserDefaults
    var defaults:UserDefaults = UserDefaults.standard
    
    //MediaPlayerのインスタンスを作成
    var player: MPMusicPlayerController!
    var query: MPMediaQuery!
    //タイマー
    var time = Timer()
    
    var timeInterval = TimeInterval()
    
    //    再生しているか停止しているかを判別するのに使う変数
        var playorpause = 0
    //    曲の再生位置の変数
        var currentTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

         if UserDefaults.standard.object(forKey: "title") != nil {
             titleArray = UserDefaults.standard.object(forKey: "title") as! [String]
             nameArray = UserDefaults.standard.object(forKey: "name") as! [String]
         }
        
        //プレイヤーの準備
        player = MPMusicPlayerController.applicationMusicPlayer
        query = MPMediaQuery.songs()
        player.setQueue(with: query)
        
//        再生バーの初期化
        slider.value = 0.0
        
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
    
    @IBAction func back() {
//        曲を止める
        
//        画面遷移を戻す
        self.dismiss(animated: true, completion: nil)
    }

}
