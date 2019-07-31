//
//  Music.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class Music: NSObject {
    var singeID:String?;
    var name:String?;
    var singer:String?;
    var songUrl:String?;
    var songTime:String?;
    
    func initMusic(name:String,singer:String) -> Music {
        let music = Music();
        music.name = name;
        music.singer = singer;
        return music;
    }
    
    func transfromQQMusic(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = (dic["song"] as! NSDictionary)["list"] as!NSArray;
        for song in list {
            let music = Music();
            music.singeID = (song as! NSDictionary).object(forKey: "id") as? String ;
            music.name = (song as! NSDictionary).object(forKey: "title") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "url") as? String;
            music.songTime = (song as! NSDictionary).object(forKey: "time_public") as? String;
            listArray.add(music);
        }
        
        return listArray;
    }
    func transfrom163Music(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = dic["songs"] as!NSArray;
        for song in list {
            let music = Music();
            music.singeID = (song as! NSDictionary).object(forKey: "id") as? String ;
            music.name = (song as! NSDictionary).object(forKey: "title") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "url") as? String;
            music.songTime = (song as! NSDictionary).object(forKey: "time_public") as? String;
            listArray.add(music);
        }
        
        return listArray;
    }
}


