//
//  SongLists.swift
//  demo
//
//  Created by uinpay on 2019/8/22.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit
import RealmSwift

class SongList: Object {
    @objc dynamic var name:String?;    //所属歌单列表
    /// LinkingObjects 反向表示该对象的拥有者
//    let owners = LinkingObjects(fromType:Music.self, property:"songList")
//    func initFromString(string:String) -> List<SongLists> {
//        var listArray = [SongLists]();
//        
//        let result = List<String>();
//        
//        return result;
//    }
    
}
