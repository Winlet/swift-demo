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
    var songUrl:NSString?;
    var songTime:NSString?;
    
    func initMusic(name:NSString,singer:NSString) -> Music {
        let music = Music();
        music.name = name;
        music.singer = singer;
        return music;
    }
    
    func transfromQQMusic(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = (dic["song"] as! NSDictionary)["list"] as!NSMutableArray;
        for song in list {
            let music = Music();
            music.singeID = (song as! NSDictionary).object(forKey: "id") as? NSString;
            music.name = (song as! NSDictionary).object(forKey: "title") as? NSString;
            music.songUrl = (song as! NSDictionary).object(forKey: "url") as? NSString;
            music.songTime = (song as! NSDictionary).object(forKey: "time_public") as? NSString;
            listArray.add(music);
        }
        
        return listArray;
    }
}


