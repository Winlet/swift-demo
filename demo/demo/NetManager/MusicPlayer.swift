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
    
    static let shared = MusicPlayer()
    
    fileprivate var player:AVAudioPlayer?
    
    /// 是否单曲循环
    fileprivate var isLoop:Bool = false
    /// 音量
    fileprivate var volume:Float = 1.0

    /// 初始化播放器
    class func setupPlayer() {
        let session = AVAudioSession.sharedInstance()
        if #available(iOS 10.0, *) {
            try? session.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers])
        }
        
        try? session.setActive(true, with: [.notifyOthersOnDeactivation])
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
        player?.numberOfLoops = 0
        player?.delegate = shared
        player?.numberOfLoops = shared.isLoop ? -1 : 0
        player?.volume = shared.volume
        
        shared.player = player
        
//        if let result = player?.prepareToPlay() {
//            if result {
//                resumePlayer()
//            }
//            return result
//        }
        
        return false
    }
    class func playTo(time:TimeInterval) {
        
        if let player = shared.player {
           
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
}

extension MusicPlayer:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: MusicPlayState.MusicPlayCompletedKey.rawValue), object: nil)
        
    }
}

