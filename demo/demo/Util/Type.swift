//
//  Type.swift
//  demo
//
//  Created by uinpay on 2019/8/2.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import Foundation

public enum MusicFromType : Int {
    /* QQ音乐*/
    case QQMusic = 100
    /* 网易云音乐*/
    case NTESMusic = 101
}

public enum MusicModeType : Int {
    /* 切歌 */
    case switchPlay = 0
    /* 播放 */
    case play  = 1
    /* 停止 */
    case stop = 2
    /* 静音 */
    case mute  = 3
    /* 音量调整 */
    case volume = 4
    /* 歌曲列表 */
    case songList = 5
    /* 歌曲循环 */
    case runLoop = 6
}
