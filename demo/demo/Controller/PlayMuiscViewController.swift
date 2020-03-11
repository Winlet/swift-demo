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
    var originList:Array<Music>?
    var index :Int!
    var playList:Array<Music>?
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playModeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var lycirTextView: UITextView!
    var timer : Timer?
    var duration : Float?
    var playMode : Int!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
        playList = originList;
        self.setup();
        let mode = UserDefaults.standard.integer(forKey: "UserModeKey");
        switchModeBtn(mode: mode%1000+1000);
        // 添加通知监听
  
        NotificationCenter.default.addObserver(self, selector: #selector(completePlayAction), name:  NSNotification.Name(rawValue: MusicPlayState.MusicPlayCompletedKey.rawValue), object: nil)
     
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func setup() {
        self.title = self.music.name;
        MusicPlayer.playMusic(Define.rootPath + "/" + self.music.localPath!);
        duration = Float(MusicPlayer.duration());
        self.endTimeLabel.text = self.dateFromTime(time:MusicPlayer.duration());
        index = playList?.firstIndex(of: music);

        var urlStr = "";
        switch music.comeType{
        case .QQMusic?:
            urlStr = Define.lyricPath + "/" + self.music.name! + "-" + self.music.songMid! + ".mp3"
            break
        case .NTESMusic?:
            urlStr = Define.lyricPath + "/" + self.music.name! + "-" + self.music.songID! + ".mp3"
            break
        default: break
        }
      
        parseLyricWithUrl(urlString: urlStr, succeed: { (result) -> () in
            var lyricStr = ""
            for  lyric in result! {
                let songLyric = lyric as! Lyric
                let lyricLine = songLyric.text as String
                lyricStr = lyricStr.appendingFormat(lyricLine).appendingFormat("\n")
            }
            if lyricStr.isEmpty {
                NetworkManager.getLyricFromMusic(music: self.music);
            }else{
                self.lycirTextView.text = lyricStr;
            }
        })
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
        self.progressSlider!.value = Float(time)/duration!;
        self.startTimeLabel.text = self.dateFromTime(time: time);

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
        //暂无功能
//        let seconds = Int64(sender.value * duration!);
//        let targetTime = CMTimeMake(seconds, Int32(duration!))
//        MusicPlayer.playTo(time: CMTimeGetSeconds(targetTime));
    }
    @IBAction func switchMode(_ sender: UIButton) {
        let userDefault = UserDefaults.standard
        
        let mode = userDefault.integer(forKey: "UserModeKey")
        var temp = mode%1000
        temp += 1;
        temp = (temp%3 + 1000);
        switchModeBtn(mode: temp);
        userDefault.set(temp, forKey: "UserModeKey")
    }
    @IBAction func lastSong(_ sender: UIButton) {
        if index == 0 {
            index = playList!.count - 1;
        }else{
            index -= 1;
        }
        self.music = playList![index];
        setup();
        self.playSong(UIButton());
        
    }
    @IBAction func playSong(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected;
        if sender.isSelected {
            self.startTimer();
                MusicPlayer.resumePlayer();

        }else{
            MusicPlayer.pausePlayer();
            self.stopTimer();
        }
        
    }
    @IBAction func nextSong(_ sender: UIButton) {
        if index == playList!.count-1 {
            index = 0;
        }else{
            index += 1;
        }
        self.music = playList![index];
        setup();
        self.playSong(UIButton());
    }
    
    @IBAction func musicList(_ sender: UIButton) {
        
    }
    @objc func completePlayAction()  {
        nextSong(UIButton());
        print("--------+-+-------next");
    }
    
    //MARK: private
    private func dateFromTime(time:TimeInterval) -> String {
        let date = Date.init(timeIntervalSince1970:time);
        
        let dfmatter = DateFormatter()
        
        dfmatter.dateFormat="m:ss"
        
        let dateStr = dfmatter.string(from: date)
        return dateStr;
    }
    
    private func switchModeBtn(mode:Int){
        switch mode {
        case  MusicModeType.runLoop.rawValue:
            self.playModeBtn.setImage(#imageLiteral(resourceName: "单曲循环"), for: UIControlState.normal)
            MusicPlayer.setLoop(true);
            break;
        case MusicModeType.allLoop.rawValue:
            self.playModeBtn.setImage(#imageLiteral(resourceName: "循环播放"), for: UIControlState.normal)
            MusicPlayer.setLoop(false);
            playList = originList;
            break;
        case MusicModeType.randomLoop.rawValue:
            self.playModeBtn.setImage(#imageLiteral(resourceName: "随机播放"), for: UIControlState.normal)
            MusicPlayer.setLoop(false);
            playList = Util.shuffleArray(arr:originList!)
            break;
        default:
            break;
        }
        playMode = mode;
    }
}
