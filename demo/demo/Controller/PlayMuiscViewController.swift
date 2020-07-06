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
import MediaPlayer

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
        if #available(iOS 9.1, *) {
            self.configRemoteCommandCenter()
        } else {
            // Fallback on earlier versions
        };
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
     //MARK: - 媒体信息配置
            ///配置多媒体控制面板的显示页面
            func mediaItemArtwork() -> Void {
                DispatchQueue.main.async {
                    let entity = self.music
                    
                    if entity != nil {
                        //根据数据配置控制项
    //                    let remoteCommandCenter = MPRemoteCommandCenter.shared()
    //                    remoteCommandCenter.likeCommand.isActive = self.currentEntity!.like
    //                    remoteCommandCenter.likeCommand.localizedTitle = (remoteCommandCenter.likeCommand.isActive == true) ? "不喜欢" : "喜欢"

                        //设置后台播放时显示的东西，例如歌曲名字，图片等
//                        let image = UIImage(named: entity!.clear!)
//                        if image != nil {
                            var info : [String : Any] = Dictionary()
                            ///标题
                        info[MPMediaItemPropertyTitle] = entity!.name
                            ///作者
//                            info[MPMediaItemPropertyArtist] = "wizet"
//                            //相簿标题
//                            info[MPMediaItemPropertyAlbumTitle] = "相册标题"
                            ///封面
//                            let artWork = MPMediaItemArtwork(boundsSize: image!.size, requestHandler: { (size) -> UIImage in return image! })
//                            info[MPMediaItemPropertyArtwork] = artWork
//
                        if self.duration != nil {
                                //当前播放进度 （会被自动计算出来，自动计算与MPNowPlayingInfoPropertyPlaybackRate设置的速率正相关)
                                info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: MusicPlayer.currentTime())
                                //调整外部显示的播放速率正常为1、一般都是根据内部播放器的播放速率作同步，一般不必修改
                                //  info[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 1)

                                //播放总时间 由当前播放的资源提供
                                info[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: self.duration!)
//                            }
                            
                            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                        }
                    }
                }
            }
    
    //MARK: - 远程控制配置
        ///配置远程控制显示的信息
    @available(iOS 9.1, *)
    func configRemoteCommandCenter() -> Void {
            let remoteCommandCenter = MPRemoteCommandCenter.shared()
            
            //播放事件
            let playCommand = remoteCommandCenter.playCommand
            playCommand.isEnabled = true
            playCommand.addTarget(self, action: #selector(playItem(_ : )))
            
            //暂停事件
            let pauseCommand = remoteCommandCenter.pauseCommand
            pauseCommand.isEnabled = true
            pauseCommand.addTarget(self, action: #selector(pauseItem(_ : )))
            
            //下一曲
            let nextTrackCommand = remoteCommandCenter.nextTrackCommand
            nextTrackCommand.isEnabled = true
            nextTrackCommand.addTarget(self, action: #selector(nextItem(_ : )))
            
            //喜欢
            let likeCommand = remoteCommandCenter.likeCommand
            likeCommand.isEnabled = true
//            switch playMode {
//            case  MusicModeType.runLoop.rawValue:
//                likeCommand.localizedTitle = "单曲循环"
//                break;
//            case MusicModeType.allLoop.rawValue:
//                likeCommand.localizedTitle = "列表循环"
//                break;
//            case MusicModeType.randomLoop.rawValue:
//                likeCommand.localizedTitle = "随机播放"
//                break;
//            default:
//                break;
//            }
            likeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
//                let mode = self.playMode
//                       var temp = mode!%1000
//                       temp += 1;
//                       temp = (temp%3 + 1000);
//                switch temp {
//                           case  MusicModeType.runLoop.rawValue:
//                               likeCommand.localizedTitle = "单曲循环"
//                               break;
//                           case MusicModeType.allLoop.rawValue:
//                               likeCommand.localizedTitle = "列表循环"
//                               break;
//                           case MusicModeType.randomLoop.rawValue:
//                               likeCommand.localizedTitle = "随机播放"
//                               break;
//                           default:
//                               break;
//                }
                self.switchMode(UIButton())
                return MPRemoteCommandHandlerStatus.success
            }

            //不喜欢
            let dislikeCommand = remoteCommandCenter.dislikeCommand
            dislikeCommand.isEnabled = true
    //          dislikeCommand.isActive = true
            dislikeCommand.localizedTitle = "上一首"
    //          dislikeCommand.localizedShortTitle = "上一首啊" (位置不明... MPFeekbackCommand.localizedShortTitle)
            dislikeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
                self.lastSong(UIButton())
                return MPRemoteCommandHandlerStatus.success
            }

            //拖动播放位置
            let changePlaybackPositionCommand = remoteCommandCenter.changePlaybackPositionCommand
            changePlaybackPositionCommand.isEnabled = true
            changePlaybackPositionCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
                //如何精确拖动的位置？
                let event = commandEvent as! MPChangePlaybackPositionCommandEvent
                MusicPlayer.playTo(time:CMTimeGetSeconds(CMTimeMakeWithSeconds(event.positionTime, 600)));
//                if self.player != nil {
//                    //需要使用带回调的SeekTime 回调重新设置进度 否则播放进度条会停止
//                    self.player?.seek(to: CMTimeMakeWithSeconds(event.positionTime, 600), completionHandler: { (finish) in
//                        //Q:拖动介绍后进度条不动了
//                            //A:恢复时重新配置MPNowPlayingInfoPropertyElapsedPlaybackTime
                        var dic = MPNowPlayingInfoCenter.default().nowPlayingInfo
                dic?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: MusicPlayer.currentTime())
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = dic
//                    })
                    return MPRemoteCommandHandlerStatus.success
//                } else {
//                    return MPRemoteCommandHandlerStatus.commandFailed
//                }
            }
            
           
            //                    let bookmarkCommand = remoteCommandCenter.bookmarkCommand
            //                    bookmarkCommand.isEnabled = true
            //                    bookmarkCommand.isActive = true
            //                    bookmarkCommand.localizedTitle = "bookmark"
            //                    bookmarkCommand.localizedShortTitle = "bookmark啊"
            //                    bookmarkCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //                        return MPRemoteCommandHandlerStatus.success
            //                    }
            
                    //上一曲
                    let previousTrackCommand = remoteCommandCenter.previousTrackCommand
                    previousTrackCommand.isEnabled = true
                    previousTrackCommand.addTarget(self, action: #selector(previousItem(_ : )))
            
            //
            //        let togglePlayPauseCommand = remoteCommandCenter.togglePlayPauseCommand
            //        togglePlayPauseCommand.isEnabled = true
            //        togglePlayPauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //            //处理
            //            return MPRemoteCommandHandlerStatus.success
            //        }
            
            //                //快进 快退
            //                let intervals : Int = 10
            //                let skipForwardCommand = remoteCommandCenter.skipForwardCommand
            //                skipForwardCommand.isEnabled = true
            //                skipForwardCommand.preferredIntervals = [NSNumber(value : intervals)]//显示在系统层面的数据
            //                skipForwardCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //                    let event = commandEvent as! MPSkipIntervalCommand
            //                    let list : [Number] = event.preferredIntervals
            //                    //根据自定义的数字进行seekTime达到快进快退效果
            //                    return MPRemoteCommandHandlerStatus.success
            //                }
            //        let skipBackwardCommand = remoteCommandCenter.skipBackwardCommand
            //        skipBackwardCommand.isEnabled = true
            //        skipBackwardCommand.preferredIntervals = [NSNumber(value : intervals)]
            //        skipBackwardCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //
            //            return MPRemoteCommandHandlerStatus.success
            //        }
            
            //        //更改播放速率
            //        let changePlaybackRateCommand = remoteCommandCenter.changePlaybackRateCommand
            //        changePlaybackRateCommand.isEnabled = true
            //        changePlaybackRateCommand.supportedPlaybackRates = [NSNumber(value : 2)]
            //        changePlaybackRateCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //            print(#function)
            //            return MPRemoteCommandHandlerStatus.success
            //        }
            //
            //        //重复模式
//                    let changeRepeatModeCommand = remoteCommandCenter.changeRepeatModeCommand
//                    changeRepeatModeCommand.isEnabled = true
//                    changeRepeatModeCommand.currentRepeatType = MPRepeatType.all
//                    changeRepeatModeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
//                        print(#function)
//                        return MPRemoteCommandHandlerStatus.success
//                    }
            
            //                let changeShuffleModeCommand = remoteCommandCenter.changeShuffleModeCommand
            //        changeShuffleModeCommand.isEnabled = true
            //        changeShuffleModeCommand.currentShuffleType = MPShuffleType.collections
            //        changeShuffleModeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //             print(#function)
            //            return MPRemoteCommandHandlerStatus.success
            //        }
            //
            ////        //评分
            //        let ratingCommand = remoteCommandCenter.ratingCommand
            //        ratingCommand.isEnabled = true
            //        ratingCommand.maximumRating = 0.0
            //        ratingCommand.maximumRating = 10.0
            //        ratingCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //             print(#function)
            //            return MPRemoteCommandHandlerStatus.success
            //        }
            
        }
    
    
    // 2.开始计时
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updataSecond), userInfo: nil, repeats: true)
        //调用fire()会立即启动计时器
        timer!.fire()
    }
    
    // 3.定时操作
    @objc func updataSecond() {
        DispatchQueue.main.async {
            let time = MusicPlayer.currentTime();
            if time > 0 && self.duration! > 0{
                let ratio = Float(time)/Float(self.duration!);
                self.progressSlider!.value = ratio;
                self.startTimeLabel.text = self.dateFromTime(time: time);
                var row = ceil(ratio*Float(self.lyricArray?.count ?? 0));
                if Int(row) ==  self.lyricArray?.count && (Int(row) != 0){
                    row = Float((self.lyricArray?.count)! - 1);
                }
                self.lyricTableView.scrollToRow(at: IndexPath(row:Int(row), section: 0), at: .middle, animated: true);
            }
            if time<0.99 {
                self.mediaItemArtwork();
            }
        }
    }
    
    // 4.停止计时
    func stopTimer() {
        if timer != nil {
            timer!.invalidate() //销毁timer
            timer = nil
        }
    }
    //MARK:MPRemoteCommand
    @objc func playItem(_ command : MPRemoteCommand) -> MPRemoteCommandHandlerStatus {
           DispatchQueue.main.async {
            self.playSong(self.playBtn)
           }
        return MPRemoteCommandHandlerStatus.success;
       }
       @objc func pauseItem(_ command : MPRemoteCommand) -> MPRemoteCommandHandlerStatus {
           DispatchQueue.main.async {
               self.playSong(self.playBtn)
           }
        return MPRemoteCommandHandlerStatus.success;
       }
       @objc func previousItem(_ command : MPRemoteCommand) -> MPRemoteCommandHandlerStatus {
           DispatchQueue.main.async {
              self.lastSong(UIButton())
           }
        return MPRemoteCommandHandlerStatus.success;
       }
       @objc func nextItem(_ command : MPRemoteCommand) -> MPRemoteCommandHandlerStatus {
           DispatchQueue.main.async {
            self.nextSong(UIButton())
           }
        return MPRemoteCommandHandlerStatus.success;
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
        self.playSong(self.playBtn);
        
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
        self.stopTimer();

    }
    @IBAction func nextSong(_ sender: UIButton) {
        if index == playList!.count-1 {
            index = 0;
        }else{
            index += 1;
        }
        self.music = playList![index];
        setup();
        self.playSong(self.playBtn);
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
            playSong(self.playBtn);
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
MPRemoteCommandCenter.shared().likeCommand.isActive = !MPRemoteCommandCenter.shared().likeCommand.isActive
        switch mode {
        case  MusicModeType.runLoop.rawValue:
            self.playModeBtn.setImage(#imageLiteral(resourceName: "单曲循环"), for: UIControlState.normal)
            MusicPlayer.setLoop(true);
            MPRemoteCommandCenter.shared().likeCommand.localizedTitle = "单曲循环"
            break;
        case MusicModeType.allLoop.rawValue:
            self.playModeBtn.setImage(#imageLiteral(resourceName: "循环播放"), for: UIControlState.normal)
            MusicPlayer.setLoop(false);
            playList = originList;
            MPRemoteCommandCenter.shared().likeCommand.localizedTitle = "列表循环"
            break;
        case MusicModeType.randomLoop.rawValue:
            self.playModeBtn.setImage(#imageLiteral(resourceName: "随机播放"), for: UIControlState.normal)
            MusicPlayer.setLoop(false);
            playList = Util.shuffleArray(arr:originList!)
            MPRemoteCommandCenter.shared().likeCommand.localizedTitle = "随机播放"
            break;
        default:
            break;
        }
        playMode = mode;
    }
}
