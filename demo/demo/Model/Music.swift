//
//  Music.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class Music: NSObject {
    var singeID:NSString?;
    var name:NSString?;
    var singer:NSString?;
    
}

func initMusic(name:NSString,singer:NSString) -> Music {
    let music = Music();
    music.name = name;
    music.singer = singer;
    return music;
}
