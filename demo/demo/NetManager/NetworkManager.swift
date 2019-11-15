//
//  NetworkManager.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser
import SWXMLHash
//import CryptoSwift


class NetworkManager: NSObject {
    
    public func searchSong(keyword word:String,from:MusicFromType,suc:@escaping (NSMutableArray)->Void,err:@escaping (NSError)->Void){
        switch from {
        case .QQMusic:
            var page = 1;
            var num = 20;
            self.searchSongFromQQMusic(keyword: word, page: &page, number: &num, suc: { (listMusic) in
                for music in listMusic{
                    print((music as! Music).name!);
                }
                suc(listMusic);
            }) { (error) in
                err(error);
            }
            break;
        case .NTESMusic:
            self.searchSongFrom163Music(keyword: word, suc: { (listMusic) in
                for music in listMusic{
                    print((music as! Music).name!);
                }
                suc(listMusic);
            }) { (error) in
                err(error);
            };
            break;
//        default:
//            break;
        case .KuGouMusic:
            self.searchSongFromKuGouMusic(keyword: word, suc: { (listMusic) in
            for music in listMusic{
                print((music as! Music).name!);
            }
            suc(listMusic);
            }, err: err);
            break;
        }
        
        
        
    }
    
    public func searchSongFromQQMusic(keyword word:String,page pageT:inout Int,number numberT:inout Int ,suc: @escaping (NSMutableArray)->Void , err:@escaping (NSError)->Void) {
        pageT = 1;
        numberT = 20;
        let wordTemp = Util.urlEncoded(string: word);
        let httpRequest = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.center&searchid=37602803789127241&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=\(pageT)&n=\(numberT)&w=\(wordTemp)&g_tk=5381&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0";
        Alamofire.request(httpRequest).responseJSON { response in
            switch response.result{
            case .success(let data):
                let dataDic = (data as! NSDictionary)["data"] as! NSDictionary
                let listMusic = Music().transfromQQMusic(dic: dataDic);
                suc(listMusic);
            case .failure(let error):
                err(error as NSError);
            }
        }
        
    }
    
    func searchSongFrom163Music(keyword word:String ,suc:@escaping (NSMutableArray)->Void,err:@escaping (NSError)->Void) {
        let wordTemp = Util.urlEncoded(string: word);
     
        //"https://music.aityp.com/search?keywords=\(wordTemp)";
        //http://music.163.com/song/media/outer/url?id=569212210

        let httpRequest = "https://music.163.com/api/search/get?s=\(wordTemp)&type=1&limit=30&offset=0";
        Alamofire.request(httpRequest).responseJSON{ (response) in
            switch response.result{
            case .success(let dataResult):
                let dataDic = (dataResult as! NSDictionary)["result"] as! NSDictionary;
                var listMusic = NSMutableArray();
                if dataDic.count != 0{
                 listMusic = Music().transfrom163Music(dic: dataDic);
                }
                suc(listMusic);
            case .failure(let error):
                err(error as NSError);
            }
        }
    }
    
    func searchSongFromKuGouMusic(keyword word:String,suc:@escaping (NSMutableArray)->Void,err:@escaping (NSError)->Void) {
        
        let wordTemp = Util.urlEncoded(string: word);
        let httpRequest = "http://mobilecdn.kugou.com/api/v3/search/song?format=json&keyword=\(wordTemp)&page=1&pagesize=20&showtype=1";
        Alamofire.request(httpRequest).responseJSON{ (response) in
            switch response.result{
            case .success(let dataResult):
                let dataDic = (dataResult as! NSDictionary)["data"] as! NSDictionary;
                var listMusic = NSMutableArray();
                if dataDic.count != 0{
                 listMusic = Music().transfromKuGouMusic(dic: dataDic);
                }
                suc(listMusic);
            case .failure(let error):
                err(error as NSError);
            }
        }
    }
    
    class func getLyricFromMusic(music:Music) {
        switch music.comeType{
        case .QQMusic?:
            self.getLyricFromQQMusic(music: music);
            break
        case .NTESMusic?:
            self.getLyricFrom163Music(music: music);
            break
        default: break
        }
    }
    
    class func getLyricFromQQMusic(music:Music) {
        /* 部分无歌词 */
                let temp = String(format: "%d/%@.xml", Int(music.songID!)!%100,music.songID!)
                let httpRequest = "http://music.qq.com/miniportal/static/lyric/" + temp;
        /*私人 api*/
//        let httpRequest = "https://v1.itooi.cn/tencent/lrc?id=\(music.songMid!)";
        Alamofire.request(httpRequest).response { (response) in
            if response.error == nil{
                let name = music.name! + "-" + music.songMid! + ".mp3";
                let res = LocalFileManager.writeLyric(string:NSString.init(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "", name: name);
                print("--------+-+-------",res);
            }else{
                
            }
        }
    }
    
    class func getLyricFrom163Music(music:Music) {
        let httpRequest = "http://music.163.com/api/song/lyric?os=pc&id=\(music.songID!)&lv=-1&kv=-1&tv=-1";
        Alamofire.request(httpRequest).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(let dataResult):
                let dataDic = (dataResult as! NSDictionary)["lrc"] as! NSDictionary;
                let lyric = dataDic.object(forKey: "lyric") as! NSString;
                let name = music.name! + "-" + music.songID! + ".mp3";
                let res = LocalFileManager.writeLyric(string:lyric, name: name);
                print("--------+-+-------",res);
            case .failure(let error):
                break;
            }
        })
    }
    
    func test(mid:String) -> String {
        "http://music.163.com/api/song/lyric?os=pc&id=569212210&lv=-1&kv=-1&tv=-1"
        "http://music.qq.com/miniportal/static/lyric/87/4944987.xml"
        "http://mobilecdn.kugou.com/api/v3/search/song?format=json&keyword=%E9%9B%AA%E8%90%BD%E4%B8%8B%E7%9A%84%E5%A3%B0%E9%9F%B3&page=1&pagesize=20&showtype=1"
        return "";
    }
}
