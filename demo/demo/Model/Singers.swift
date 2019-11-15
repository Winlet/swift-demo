//
//  Singers.swift
//  demo
//
//  Created by uinpay on 2019/8/1.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit
import RealmSwift

class Singers: Object {
    @objc dynamic var singerID:String?
    @objc dynamic var name:String?
    
    /// LinkingObjects 反向表示该对象的拥有者
//    let owners = LinkingObjects(fromType:Music.self, property:"singer")
    
    func initFromArray(array:Array<Dictionary<String, Any>>) -> List<Singers> {
        var listArray = [Singers]();
        for singerDic in array {
            let Singer = Singers();
            Singer.singerID = NumberFormatter.init().string(from:singerDic["id"] as! NSNumber);
            Singer.name = (singerDic["name"] as! String);
            listArray.append(Singer);
        }
        let result = List<Singers>();
        result.append(objectsIn: listArray);
        return result;
    }
    
    func initFrom(name:String,id:String) -> List<Singers> {
        var listArray = [Singers]();
       
            let Singer = Singers();
            Singer.singerID = id;
            Singer.name = name;
            listArray.append(Singer);
        let result = List<Singers>();
        result.append(objectsIn: listArray);
        return result;
    }
}
