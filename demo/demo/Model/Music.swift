//
//  Music.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class Music: NSObject {
    var songID:String?;    //歌曲ID
    var name:String?;       //歌曲名字
    var songUrl:String?;    //歌曲链接
    var songMid:String?;    //专用ID
    
    var singer:Array<Singers>?;//歌手列表
    
    var songTime:String?;   //发布时间 TODO:后期转专辑对象属性
    
//    func initMusic(name:String,singer:String) -> Music {
//        let music = Music();
//        music.name = name;
//        music.singer = singer;
//        return music;
//    }
    
    func transfromQQMusic(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = (dic["song"] as! NSDictionary)["list"] as!NSArray;
        for song in list {
            let music = Music();
            music.songID = NumberFormatter.init().string(from:(song as! NSDictionary).object(forKey: "id") as! NSNumber) ;
            music.name = (song as! NSDictionary).object(forKey: "title") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "url") as? String;
            music.songTime = (song as! NSDictionary).object(forKey: "time_public") as? String;
            music.songMid = (song as! Dictionary<String,Any>)["mid"] as? String;
            music.singer = Singers().initFromArray(array: (song as! NSDictionary).object(forKey: "singer") as! Array);
            listArray.add(music);
        }
        
        return listArray;
    }
    func transfrom163Music(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = dic["songs"] as!NSArray;
        for song in list {
            let music = Music();
            music.songID = NumberFormatter.init().string(from:(song as! NSDictionary).object(forKey: "id") as! NSNumber)  ;
            music.name = (song as! NSDictionary).object(forKey: "name") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "rUrl") as? String;
            music.singer = Singers().initFromArray(array: (song as! NSDictionary).object(forKey: "artists") as! Array)
            listArray.add(music);
        }
        return listArray;
    }
}


