//
//  PlayMuiscViewController.swift
//  demo
//
//  Created by U-NAS on 2018/9/3.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import CoreMedia

class PlayMuiscViewController: UIViewController {
    var music :Music!
    var playList:Array<Music>?
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playModeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    var progress:Int?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
        progress = 0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // 2.开始计时
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updataSecond), userInfo: nil, repeats: true)
        //调用fire()会立即启动计时器
        timer!.fire()
    }
    
    // 3.定时操作
    @objc func updataSecond() {
        
        let time = MusicPlayer.currentTime();
        self.progressSlider!.value = Float(time);
        let date = Date.init(timeIntervalSince1970:time);
        
        let dfmatter = DateFormatter()
        
        dfmatter.dateFormat="m:ss"
        
        let dateStr = dfmatter.string(from: date)
        self.startTimeLabel.text = dateStr;
//        MusicPlayer
//            stopTimer()
    }

    // 4.停止计时
    func stopTimer() {
        if timer != nil {
            timer!.invalidate() //销毁timer
            timer = nil
        }
    }
    //MARK: Action
    @IBAction func switchProgress(_ sender: UISlider) {
        let seconds : Int64 = Int64(sender.value)
        let targetTime = CMTimeMake(seconds, 1)
        print("--------+-+-------");
//        MusicPlayer.shared.time = targetTime;
    }
    @IBAction func switchMode(_ sender: UIButton) {
    }
    @IBAction func lastSong(_ sender: UIButton) {
    }
    @IBAction func playSong(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected;
        if sender.isSelected {
            self.startTimer();
            if progress==0 {
                MusicPlayer.playMusic(self.music.localPath!);
            }else{
                let seconds : Int64 = Int64(self.progressSlider.value)
                let targetTime = CMTimeMake(seconds, 1)
//                MusicPlayer.resumePlayer(time: targetTime);
            }
        }else{
            MusicPlayer.pausePlayer();
            self.stopTimer();
        }
        
    }
    @IBAction func nextSong(_ sender: UIButton) {
    }
    
    @IBAction func musicList(_ sender: UIButton) {
    }
}
