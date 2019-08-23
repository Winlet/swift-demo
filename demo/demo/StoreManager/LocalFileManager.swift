//
//  LocalFileManager.swift
//  demo
//
//  Created by uinpay on 2019/8/7.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit

class LocalFileManager: NSObject {
    static var defaultManager:FileManager!
    
    
}

extension LocalFileManager {
    
    class public func writeLyric(string:NSString , name:String)->Bool {
    
        let  fileManager = FileManager.default
        
        let result = fileManager.fileExists(atPath:Define.lyricPath)
        if result {
        }else{
            do {
                try fileManager.createDirectory(atPath: Define.lyricPath, withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print("creat false %@",error)
            }
        }
        
        if string != "" {
            let localPath = Define.lyricPath + "/" + name
            do {
                try string.write(toFile: localPath, atomically: false, encoding: String.Encoding.utf8.rawValue)
            } catch let error{
                print(error);
                return false;
            }
        }else{
            return false;
        }
       
       return true;
    }
    class public func deleteLyric(key:String )->Bool{
        let localPath = Define.lyricPath + "/" + key;
         let  fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: localPath)
        } catch let error {
            print(error);
            return false;
        }
        return true;
    }
    class public func deleteMusicFile(key:String )->Bool{
        let localPath = Define.rootPath + "/" + key;
        let  fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: localPath)
        } catch let error {
            print(error);
            return false;
        }
        return true;
    }
    
    class public func readSongList() -> Array<String>{
        var temp : [String];
        let arr = UserDefaults.standard.value(forKey: Define.listKey)
        if arr != nil {
            temp = Array.init(arr as! Array);
        }else{
            temp = Array.init();
        }
        return temp;
    }
    class public func createSongList(name:String) {
        var temp : [String];
        let arr = UserDefaults.standard.value(forKey: Define.listKey)
        if arr != nil {
            temp = Array.init(arr as! Array);
        }else{
            temp = Array.init();
        }
        temp.append(name);
        UserDefaults.standard.set(temp, forKey:Define.listKey);
    }
    class public func deleteSongList(name:String) {
        var temp : [String];
        let arr = UserDefaults.standard.value(forKey: Define.listKey)
        if arr != nil {
            temp = Array.init(arr as! Array);
        }else{
            temp = Array.init();
        }
    
       let index = temp.index(of: name)
        temp.remove(at: index!);
        UserDefaults.standard.set(temp, forKey:Define.listKey);
    }
}
