//
//  Lyric.swift
//  demo
//
//  Created by uinpay on 2019/8/9.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit

class Lyric: NSObject {
    /// 开始显示的秒数
    var total:NSNumber = 0.0
    /// 开始显示的时间
    var time:NSString  = ""
    /// 歌词文本
    var text:NSString  = ""

}

/**
 *解析歌词
 */
func parseLyricWithUrl(urlString:String, succeed:(NSArray?)->()){
    if (urlString.isEmpty){
        return
    }
//    let url : NSURL = NSURL(string:urlString as String)!
    //    let lyc : NSString = NSString(contentsOfURL: url, encoding:NSUTF8StringEncoding) as NSString
    
    var lyc:NSString = ""
    
    do {
        lyc = try String(contentsOfFile: urlString, encoding: String.Encoding.utf8) as NSString
//        lyc = try String(contentsOf:url as URL, encoding:String.Encoding.utf8) as NSString
    } catch {
        
    }
    
    NSLog("获取到歌词文件内容:%@", lyc)
    let result:NSMutableArray = NSMutableArray()
    for lStr in lyc.components(separatedBy: "\n") {
        
        //        var arr = lStr.componentsSeparatedByString("]")
        
        
        let item:NSString = lStr as NSString
        if(item.length>0){
            //            let dic:NSDictionary = NSDictionary()
            let startrange:NSRange = item.range(of: "[")
            let stoprange:NSRange = item.range(of: "]")
            if stoprange.length == 0{
                //歌词没时间
                let songLrc:Lyric = Lyric()
                songLrc.total=NSNumber(value: -1)//开始显示的秒数
                songLrc.time=""//开始显示时间
                songLrc.text=item//显示的歌词
                result.add(songLrc)
                
            }else{
                let content:NSString = item.substring(with: NSMakeRange(startrange.location+1, stoprange.location-startrange.location-1)) as NSString
                //歌词有时间
                if (content.length >= 8) {
                    let minute:NSString = content.substring(with: NSMakeRange(0, 2)) as NSString
                    let second:NSString = content.substring(with: NSMakeRange(3, 2)) as NSString
                    let mm:NSString = content.substring(with: NSMakeRange(6, 2)) as NSString
                    let time:NSString = NSString(format: "%@:%@.%@", minute,second,mm)
                    let total:NSNumber = NSNumber(value: minute.integerValue * 60 + second.integerValue)
                    let lyric:NSString = item.substring(from: content.length+2) as NSString
                    
                    let songLrc:Lyric = Lyric()
                    songLrc.total=total//开始显示的秒数
                    songLrc.time=time//开始显示时间
                    
//                    if lyric.length == 0 {
//                        lyric = "。。。。。。。"
//                    }
                    
                    songLrc.text=lyric//显示的歌词
                    result.add(songLrc)
                }
            }
            
        }
    }
//    if result.count > 0 {
        succeed(result)
//    }
}
