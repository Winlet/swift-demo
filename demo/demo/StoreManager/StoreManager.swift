//
//  StoreManager.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import RealmSwift

class StoreManager: Object {
    static var defaultRealm:Realm!
    
    private class func getDB() -> Realm {

        if defaultRealm != nil {
            return defaultRealm;
        }else{
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/MusicsDB.realm")
        /// 传入路径会自动创建数据库
        defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
        }
    }
    /// 配置数据库
    class func configRealm() {
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
        let dbVersion : UInt64 = 3
        
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/MusicsDB.realm")
        
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                print("Realm 服务器配置成功!")
            }else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
}

extension StoreManager {
    /// 增
    public class func insertMusic(by music : Music) -> Void {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(music)
        }
    }
    //删
    public class func deleteMusic(by music : Music){
        let defaultRealm = self.getDB()
        print(LocalFileManager.deleteLyric(key:music.localPath!));
        print(LocalFileManager.deleteMusicFile(key:music.localPath!));
        
        try! defaultRealm.write {
            
            defaultRealm.delete(music.songLists);
            defaultRealm.delete(music.singer);
            defaultRealm.delete(music)
//            realm.delete(dogs) // 删除单个数据 删除多个数据
//            realm.deleteAll() // 从 Realm 中删除所有数据
        }
    }
    
    public class func getAllMusic() ->Array<Music>{
        var results : Array<Music>;
        results = Array();
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
        let result = defaultRealm.objects(Music.self);
        results.append(contentsOf: result);
        }
        return results;
    }
    //查
    public class func queryMusic(by path:String) -> Music{
        let realm = self.getDB();
        var music : Music!;
        try! defaultRealm.write {
        music = realm.object(ofType: Music.self, forPrimaryKey: path);
        }
        return music;
    }
    //MARK: 循环列表存储
    //获取循环列表
    class public func getLoopMusic() -> Array<Music> {
        var result = [Music]();
        
        let defaultRealm = self.getDB()
        do {
            try defaultRealm.write {
                let allList = defaultRealm.objects(Music.self);
                for music in allList{
                    if (music.songLists.index(matching: "name == %@","loop" as Any) != nil){
                        result.append(music);
                    }
                }
            }
        } catch let error {
            print(error);
        }
        return result;
    }
    
    //所以歌曲-循环列表
    class public func getLastLoopMusic() -> Array<Music>{
        var result = [Music]();
        
        let defaultRealm = self.getDB()
        do {
            try defaultRealm.write {
                let allList = defaultRealm.objects(Music.self);
                for music in allList{
                    if (music.songLists.filter("name == %@","loop" as Any).count == 0){
                        result.append(music);
                    }
                }
            }
        } catch let error {
            print(error);
        }
        return result;
    }
    //存入循环列表
    class public func writeToLoopMusic(list:Array<Music>)->Bool {
        
        let defaultRealm = self.getDB()
        do {
            try defaultRealm.write {
                let s = SongList.init();
                s.name = "loop";
                for music in list{
                    if (music.songLists.filter("name == %@","loop" as Any).count == 0){
                        music.songLists.append(s);
                    }
                }
            }
        } catch let error {
            print(error);
            return false;
        }
        return true;
    }
    //清空
    class public func clearLoopMusic() {
        let defaultRealm = self.getDB()
        do {
            try defaultRealm.write {
                let allList = defaultRealm.objects(Music.self);
                for music in allList{
                        let index = music.songLists.index(matching: "name == %@","loop" as Any);
                        if index != nil {
                            let sa = music.songLists[index!];
                            defaultRealm.delete(sa);
                        }
                }
            }
        } catch let error {
            print(error);
        }
    }
}
