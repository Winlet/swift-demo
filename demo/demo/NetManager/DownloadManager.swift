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
        
        let ducumentPath = NSHomeDirectory() + "/Documents"
        let localPath = ducumentPath + "/Downloads"
        let  fileManager = FileManager.default
        
        let result = fileManager.fileExists(atPath: localPath)
        
        if result {
            print("yes")
        }else{
            do {
                try fileManager.createDirectory(atPath: localPath, withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print("creat false %@",error)
            }
        }
        let url = URL(fileURLWithPath:localPath);
        
        //下载存储路径
        let destination: DownloadRequest.DownloadFileDestination =  {_,response in
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            let fileUrl = url.appendingPathComponent("怪咖")
            print(fileUrl)
            return (fileUrl,[.removePreviousFile, .createIntermediateDirectories] )
        }
        
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
//        }
//        let destination: (NSURL, HTTPURLResponse) -> (NSURL) = {
//            (temporaryURL, response) in
//            if let directoryURL = localPath as? NSURL {
//                return directoryURL.appendingPathComponent("\("asd").\(response.suggestedFilename)")! as (NSURL)
//            }
//            return temporaryURL
//        }

//        let destination = DownloadRequest.suggestedDownloadDestination()
        
//        let destination = DownloadRequest.suggestedDownloadDestination()
//        http://music.163.com/song/media/outer/url?id=574921549.mp3
        
        var urlS =  "http://music.163.com/song/media/outer/url?id=574921549.mp3";
        
        Alamofire.download(urlS, to: destination).response { response in // method defaults to `.get`
            print(response.request)
            print(response.response)
            print(response.temporaryURL)
            print(response.destinationURL)
            print(response.error)
        }
        
        let error = NSError();
        err(error);
    }
}
