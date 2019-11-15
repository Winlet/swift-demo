//
//  Music.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import RealmSwift

class Music: Object {
    @objc dynamic var songID:String?;    //歌曲ID
    @objc dynamic var name:String?;       //歌曲名字
//     dynamic var type:Int?;//歌曲来源
    @objc dynamic private var type = 1
    @objc dynamic var songUrl:String?;    //歌曲链接
    @objc dynamic var songMid:String?;    //专用ID
    
    @objc dynamic var localPath:String?;  //本地路径 本地文件名 歌名-各系统唯一id组成
    
    
    var singer = List<Singers>();//歌手列表
    var songLists = List<SongList>();//所属歌单列表
    
    
    @objc dynamic var songTime:String?;   //发布时间 TODO:后期转专辑对象属性
    
    //所属枚举对应的get、set方法
    var comeType: MusicFromType? {
        get {
            return MusicFromType(rawValue: type);
        }
        set {
            type = newValue?.rawValue ?? 0
        }
    }
    
    
    
    //设置主键
    override class func primaryKey() -> String? {
        return "localPath"
    }
    
    func initMusic(name:String,_ singer:String,path:String) -> Music {
        let music = Music();
        music.name = name;
        music.songID = singer;
        music.localPath = path;
        return music;
    }
    
    func transfromQQMusic(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = (dic["song"] as! NSDictionary)["list"] as!NSArray;
        for song in list {
            let music = Music();
            music.comeType = .QQMusic;
            music.songID = NumberFormatter.init().string(from:(song as! NSDictionary).object(forKey: "id") as! NSNumber) ;
            music.name = (song as! NSDictionary).object(forKey: "title") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "url") as? String;
            music.songTime = (song as! NSDictionary).object(forKey: "time_public") as? String;
            music.songMid = (song as! Dictionary<String,Any>)["mid"] as? String;
            music.singer = Singers().initFromArray(array: (song as! NSDictionary).object(forKey: "singer") as! Array);
            music.localPath = music.name! + "-" + music.songMid! + ".mp3";
            listArray.add(music);
        }
        
        return listArray;
    }
    func transfrom163Music(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = dic["songs"] as!NSArray;
        for song in list {
            let music = Music();
            music.comeType = .NTESMusic;
            music.songID = NumberFormatter.init().string(from:(song as! NSDictionary).object(forKey: "id") as! NSNumber)  ;
            music.name = (song as! NSDictionary).object(forKey: "name") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "rUrl") as? String;
            music.singer = Singers().initFromArray(array: (song as! NSDictionary).object(forKey: "artists") as! Array)
            music.localPath = music.name! + "-" + music.songID! + ".mp3";
            listArray.add(music);
        }
        return listArray;
    }
    func transfromKuGouMusic(dic:NSDictionary) ->NSMutableArray{
        
        let listArray = NSMutableArray();
        let list = dic["info"] as!NSArray;
        for song in list {
            let music = Music();
            music.comeType = .KuGouMusic;
            music.songID = (song as! NSDictionary).object(forKey: "hash") as? String  ;
            music.name = (song as! NSDictionary).object(forKey: "songname_original") as? String;
            music.songUrl = (song as! NSDictionary).object(forKey: "hash") as? String;
            music.singer = Singers().initFrom(name: ((song as! NSDictionary).object(forKey: "singername") as! String), id: (song as! NSDictionary).object(forKey: "songname") as! String)
            music.localPath = music.name! + "-" + music.songID! + ".mp3";
            listArray.add(music);
        }
        return listArray;
    }
}


