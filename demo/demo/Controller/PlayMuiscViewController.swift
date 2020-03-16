//
//  PlayMuiscViewController.swift
//  demo
//
//  Created by U-NAS on 2018/9/3.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class PlayMuiscViewController: UIViewController ,MusicDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    var music :Music!
    var originList:Array<Music>?
    var index :Int!
    var playList:Array<Music>?
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playModeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var lyricTableView: UITableView!
    
    var timer : Timer?
    var duration : TimeInterval?
    var playMode : Int!;
    var lyricArray : Array<Lyric>?
    //MARK:UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
        playList = originList;
        self.setup();
        MusicPlayer.shared.delegate = self;
        let mode = UserDefaults.standard.integer(forKey: "UserModeKey");
        switchModeBtn(mode: mode%1000+1000);
        // 添加通知监听
        
        NotificationCenter.default.addObserver(self, selector: #selector(completePlayAction), name:  NSNotification.Name(rawValue: MusicPlayState.MusicPlayCompletedKey.rawValue), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(InterruptionPlayAction), name:  NSNotification.Name(rawValue: MusicPlayState.MusicPlayInterruptionKey.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(InterruptionPlayAction), name: .AVAudioSessionInterruption, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: .AVAudioSessionRouteChange, object:nil);
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func setup() {
        self.title = self.music.name;
        self.lyricTableView.allowsSelection = false;
        self.lyricTableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
        MusicPlayer.playMusic(Define.rootPath + "/" + self.music.localPath!);
        duration = MusicPlayer.duration();
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
            lyricArray = Array();
            for  lyric in result! {
                let songLyric = lyric as! Lyric
                let lyricLine = songLyric.text as String
                lyricArray?.append(songLyric);
                lyricStr = lyricStr.appendingFormat(lyricLine).appendingFormat("\n")
            }
            if lyricStr.isEmpty {
                NetworkManager.getLyricFromMusic(music: self.music);
            }else{
                lyricTableView.reloadData();
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
        let ratio = Float(time)/Float(duration!);
        self.progressSlider!.value = ratio;
        self.startTimeLabel.text = self.dateFromTime(time: time);
        var row = ceil(ratio*Float(self.lyricArray?.count ?? 0));
        if Int(row) ==  self.lyricArray?.count && (Int(row) != 0){
            row = Float((self.lyricArray?.count)! - 1);
        }
        self.lyricTableView.scrollToRow(at: IndexPath(row:Int(row), section: 0), at: .middle, animated: true);
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
        let seconds = Double(sender.value) * (duration ?? 0);
        MusicPlayer.playTo(time:seconds);
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
    func stopPlay() {
        self.playBtn.isSelected = false;
        MusicPlayer.pausePlayer();
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
    //MARK:lyricTableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyricArray?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: "LyricCell")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "LyricCell")
        }
        let lyric = self.lyricArray![indexPath.row];
        cell?.textLabel?.text = lyric.text as String;
        cell?.textLabel?.numberOfLines = 0 ;
        return cell!;
    }
    //MARK:状态变更
    @objc func completePlayAction()  {
        nextSong(UIButton());
    }
    
    @objc func InterruptionPlayAction(_ notification: Notification){
        stopPlay();
    }
    
    @objc func handleRouteChange(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
        }
        switch reason {
        case .newDeviceAvailable:
            // Handle new device available.
            playSong(UIButton());
        case .oldDeviceUnavailable:
            // Handle old device removed.
            stopPlay();
        default: ()
        }
        
    }
    
    //MARK:Delegate
    func PlayTimeChange(time: Float) {
        print("_____",time);
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
