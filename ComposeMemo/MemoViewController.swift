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
    
    //MediaPlayerのインスタンスを作成
    var player: MPMusicPlayerController!
    var query: MPMediaQuery!
    //タイマー
    var time = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //プレイヤーの準備
        player = MPMusicPlayerController.applicationMusicPlayer
        query = MPMediaQuery.songs()
        player.setQueue(with: query)
        
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
        //オーディオを再生
        player.play()
    }

}
