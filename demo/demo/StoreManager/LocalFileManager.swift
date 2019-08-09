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
    
    class public func getLoopMusic() -> Array<Music> {
        var result = [Music]();
        
        let localPath = Define.docPath + "/" + "loopMusics"
        let res = NSArray(contentsOfFile: localPath);
        if res != nil {
            for str in res!{
                result.append(StoreManager.queryMusic(by: str as! String));
            }
        }
        return result;
    }
    
    class public func getLastLoopMusic() -> Array<Music>{
        var result = Array.init(StoreManager.getAllMusic());
        let localPath = Define.docPath + "/" + "loopMusics"
        let res = NSArray(contentsOfFile: localPath);
        if res != nil {
            for str in res!{
                let index = result.firstIndex { (music) -> Bool in
                    (music.localPath == str as? String);
                }
                result.remove(at: index!);
            }
        }
        return result;
    }
    
    class public func writeToLoopMusic(list:Array<Music>)->Bool {
        
        var temp = Array<String>();
        let localPath = Define.docPath + "/" + "loopMusics"
        for music in list{
            temp.append(music.localPath!);
        }
        let result = NSArray.init(array: temp);
        if result.count == 0{
            return false;
        }else{
            return result.write(toFile: localPath, atomically: false);
        }
    }
    
    class public func clearLoopMusic() {
        let fileManager = FileManager.default
        let localPath = Define.docPath + "/" + "loopMusics"
        try? fileManager.removeItem(atPath: localPath);
    }
    
    class public func writeLyric(string:NSString , name:String)->Bool {
    
        let localPath = Define.lyricPath + "/" + name
        return ((try? string.write(toFile: localPath, atomically: false, encoding: String.Encoding.utf8.rawValue)) != nil);
        
    }
    
}
