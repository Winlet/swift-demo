//
//  MusicPlayer.swift
//  demo
//
//  Created by uinpay on 2019/8/2.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayer: NSObject {
//    static let shared = MusicPlayer()
    
    weak var delegate : MusicDelegate?
    
    fileprivate var player:AVAudioPlayer?
    
    /// 是否单曲循环
    fileprivate var isLoop:Bool = false
    /// 音量
    fileprivate var volume:Float = 1.0
    
    var currentTimeT:Float = 0 {
        willSet {   //新值设置之前被调用
            print("willSet的新值是\(newValue)")
        }
        didSet { //新值设置之后立即调用
            print("didSet的新值是\(oldValue)")
        }
    }
    ///单例
    static let shared: MusicPlayer = {
        let shared = MusicPlayer()
        UIApplication.shared.beginReceivingRemoteControlEvents();
        // setup code
        return shared
    }()
    /// 初始化播放器
    class func setupPlayer() {
//        let session = AVAudioSession.sharedInstance()
//        if #available(iOS 10.0, *) {
//            try? session.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers])
//        }
//
//        try? session.setActive(true, with: [.notifyOthersOnDeactivation])
//        if session.category == AVAudioSessionCategorySoloAmbient {
//
//        } else {
//            try? session.setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
//            try? session.setCategory(AVAudioSessionCategorySoloAmbient, with: AVAudioSessionCategoryOptions())//默认模式
//        }
        //配置后台播放
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category == AVAudioSessionCategoryPlayback {
        } else {
            try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
            try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions())//取消混合和duck模式
        }
    }
    
    
    /// 播放切换歌曲
    ///
    /// - Parameter filePath: <#filePath description#>
    /// - Returns: <#return value description#>
    @discardableResult
    class func playMusic(_ filePath:String) -> Bool {
//        let player = try? AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:filePath))
        
        let dat = try? Data.init(contentsOf: URL(fileURLWithPath:filePath));
        let player = try? AVAudioPlayer.init(data: dat!);
        shared.player = player
        player?.numberOfLoops = 0
        player?.delegate = shared
        player?.numberOfLoops = shared.isLoop ? -1 : 0
        player?.volume = shared.volume
        shared.currentTimeT = Float(player?.currentTime ?? 0);
//        player!.addObserver(shared, forKeyPath: "currentTime", options: .new, context: nil);
//        if let result = player?.prepareToPlay() {
//            if result {
//                resumePlayer()
//            }
//            return result
//        }
        
        return false
    }
    class func playTo(time:Double) {
        if let player = shared.player {
            player.currentTime = time;
        }
    }
    class func resumePlayer() {
        if let player = shared.player,!player.isPlaying {
            player.play()
        }
    }
    
    class func pausePlayer() {
        if let player = shared.player,player.isPlaying {
            player.pause()
        }
    }
    
    class func stopPlayer() {
        if let player = shared.player, player.isPlaying {
            player.stop()
        }
    }
    
    class func setLoop(_ isLoop:Bool = false) {
        if let player = shared.player {
            player.numberOfLoops = isLoop ? -1 : 0
        }
        shared.isLoop = isLoop
    }
    
    class func updateVolume(_ volume:Float) {
        if let player = shared.player {
            player.volume = volume
            player.updateMeters()
        }
        
        shared.volume = volume
    }
    //当前时间
    class func currentTime()->TimeInterval{
        
        return shared.player?.currentTime ?? 0;
    }
    //全部时长
    class func duration()->TimeInterval {
        return shared.player?.duration ?? 0;
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentTime" {
           if let value = change?[NSKeyValueChangeKey.newKey] as? Float {
            if (self.delegate?.responds(to: Selector.init(("PlayTimeChange"))))! {
                self.delegate?.PlayTimeChange(time: value);
            }
            }
        }
        
    }
    
}

extension MusicPlayer:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: MusicPlayState.MusicPlayCompletedKey.rawValue), object: nil)
        
    }
    
}

protocol MusicDelegate:NSObjectProtocol {
    func PlayTimeChange(time:Float);
}

