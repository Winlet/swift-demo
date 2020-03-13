//
//  Type.swift
//  demo
//
//  Created by uinpay on 2019/8/2.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import Foundation

public enum Define {
    static let docPath = NSHomeDirectory() + "/Documents"
    static let rootPath = NSHomeDirectory() + "/Documents" + "/Downloads";
    static let lyricPath = NSHomeDirectory() + "/Documents" + "/Lyrics";
    static let orderPath = NSHomeDirectory() + "/Documents" + "/MusicList";
    static let listKey = "songList";
}

public enum MusicFromType : Int {
    /* QQ音乐*/
    case QQMusic = 100
    /* 网易云音乐*/
    case NTESMusic = 101
    /* 酷狗**/
    case KuGouMusic = 102
}

public enum MusicModeType : Int {
    /* 单曲循环 */
    case runLoop = 1000
    /* 全部循环 */
    case allLoop = 1001
    /* 随机循环 */
    case randomLoop = 1002
    
}
public enum MusicPlayState : String {
    /* 播放完成*/
    case MusicPlayCompletedKey = "playCompleted"
    case MusicPlayInterruptionKey = "playInterruption";
    
}
