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
    
    func download(music:Music,progerss:@escaping (CGFloat)->Void ,suc:@escaping ()->Void,err:@escaping (Error)->Void) {
        
        switch music.comeType{
        case .QQMusic?:
            self.downloadFromQQMusic(mid: music.songMid!, name: music.name!, suc: suc, err: err);
            break
        case .NTESMusic?:
            self.downloadFrom163Music(id: music.songID!, name: music.name!, suc: suc, err: err);
            break
        default: break
        }
       
        
    }
    
    
    func downloadFromQQMusic(mid:String,name:String,suc:@escaping ()->Void,err:@escaping (Error)->Void) {
        
        /*私人api 存在日后维护问题*/
        let uuid = name + "-" + mid;
        let downloadUrl = "https://v1.itooi.cn/tencent/url?id=\(mid)&quality=128"
        self.downloadSongForUrl(requestUrl: downloadUrl, name: uuid, suc: suc, err: err);
        return;
        /*原方法 部分歌曲无法下载
         但它是通用官方的api
         */
        let guid = "8383045540";
        let filename = "C400"+mid+".m4a";
        let requestUrl = "https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?g_tk=5381&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0&cid=205361747&uin=0&songmid=\(mid)&filename=\(filename)&guid=\(guid)"
        Alamofire.request(requestUrl).responseJSON { (response) in
            switch response.result{
            case .success(let data):
                let dic = (data as! Dictionary<String,Any>)["data"];
                let array = (dic as! Dictionary<String,Any>)["items"];
                let vkey = (array as! Array<Dictionary<String,Any>>).first!["vkey"];
                //file type wrong ...vkey 为空
                let downloadUrl = "http://dl.stream.qqmusic.qq.com/\(filename)?vkey=\(vkey ?? "" )&guid=\(guid)&uin=0&fromtag=66";
                let uuid = name + "-" + mid;
                self.downloadSongForUrl(requestUrl: downloadUrl, name: uuid, suc: suc, err: err);
            case .failure(let error):
                err(error);
            }
        }
        return;
    }
    
    func downloadFrom163Music(id:String,name:String,suc:@escaping ()->Void,err:@escaping (Error)->Void) {
        let downloadUrl = "http://music.163.com/song/media/outer/url?id=" + id + ".mp3";
        let uuid = name + "-" + id;
        self.downloadSongForUrl(requestUrl: downloadUrl, name: uuid, suc: suc, err: err);
    }
    
    public func downloadSongForUrl(requestUrl:String,name:String, suc:@escaping ()->Void , err:@escaping (Error)->Void){
        
        let  fileManager = FileManager.default
        
        let result = fileManager.fileExists(atPath:Define.rootPath)
        if result {
        }else{
            do {
                try fileManager.createDirectory(atPath: Define.rootPath, withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print("creat false %@",error)
            }
        }
        let url = URL(fileURLWithPath:Define.rootPath);
        
        //下载存储路径
        let destination: DownloadRequest.DownloadFileDestination =  {_,response in
            let nameUUID = name+".mp3"
            let fileUrl = url.appendingPathComponent(nameUUID)
            print(fileUrl)
            return (fileUrl,[.removePreviousFile, .createIntermediateDirectories] )
        }
        
        Alamofire.download(requestUrl, to: destination).response { response in // method defaults to `.get`
            if response.error != nil{
                err(response.error!);
            }else{
                suc();
            }
        }
    }
}
