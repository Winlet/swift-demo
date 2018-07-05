//
//  DownloadManager.swift
//  demo
//
//  Created by U-NAS on 2018/7/4.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import Alamofire

class DownloadManager: NSObject {

    public func downloadSongForUrl(url:NSString , suc:()->Void , err:(NSError)->Void){
//        http://music.163.com/song/media/outer/url?id=574921549.mp3
        
        let error = NSError();
        err(error);
    }
}
