//
//  Singers.swift
//  demo
//
//  Created by uinpay on 2019/8/1.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit

class Singers: NSObject {
    var singerID:String?
    var name:String?
    
    func initFromArray(array:Array<Dictionary<String, Any>>) -> Array<Singers> {
        var listArray = [Singers]();
        for singerDic in array {
            let Singer = Singers();
            Singer.singerID = NumberFormatter.init().string(from:singerDic["id"] as! NSNumber);
            Singer.name = (singerDic["name"] as! String);
            listArray.append(Singer);
        }
        return listArray;
    }
    
}
