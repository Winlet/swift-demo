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
    
    public func searchSong(keyword word:String,suc:@escaping (NSMutableArray)->Void,err:@escaping (NSError)->Void){
 
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
        
//        self.searchSongFrom163Music(keyword: word, suc: { (listMusic) in
//            for music in listMusic{
//                print((music as! Music).name!);
//            }
//            suc(listMusic);
//        }) { (error) in
//            err(error);
//        };
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
        // https://music.aityp.com/
        //https://music.163.com/api/search/get?s=%22123%22&type=1&limit=30&offset=0
        //http://music.163.com/song/media/outer/url?id=569212210
        let httpRequest = "https://music.aityp.com/search?keywords=\(wordTemp)";
        Alamofire.request(httpRequest).responseJSON{ (response) in
            switch response.result{
            case .success(let dataResult):
                let dataDic = (dataResult as! NSDictionary)["result"] as! NSDictionary;
                let listMusic = Music().transfrom163Music(dic: dataDic);
                suc(listMusic);
            case .failure(let error):
               err(error as NSError);
            }
        }
    }
    
    class func getLyricFromQQMusic(music:Music) {
//        let temp = Int(music.songID!)%100 + "/" + music.songID! + ".xml";
        
        let temp = String(format: "%d/%@.xml", Int(music.songID!)!%100,music.songID!)
        let httpRequest = "http://music.qq.com/miniportal/static/lyric/" + temp;
        Alamofire.request(httpRequest).response { (response) in
//            let xml1 = SWXMLHash.parse(response.data!)
//            switch xml1 {
//            case .xmlError(let error):
//                print("--------+-+-------1");
//                break;
//            case .element(_):
//                print("--------+-+-------12");
//                break;
//            case .list(_):
//                print("--------+-+-------13");
//                break;
//            case .stream(_):
//                print("--------+-+-------14");
//                break;
//            case .parsingError(_):
//                print("--------+-+-------15");
//                break;
//            }
//            return;
            let xml = try! XML.parse(response.data!)
            switch xml {
            case .failure(let error):
                print("--------+-+-------1");
                break;
            case .singleElement(_):
                print("--------+-+-------2");
                let element = xml["lyric"];
                let name = music.name! + "-" + music.songMid! + ".mp3";
                let res = LocalFileManager.writeLyric(string: element.text! as NSString, name: name);
                print("--------+-+-------10",res);
                break;
            case .sequence(_):
                print("--------+-+-------3");
                break;
            }
        }
    }
    
    func test(mid:String) -> String {
        "http://music.163.com/api/song/lyric?os=pc&id=569212210&lv=-1&kv=-1&tv=-1"
        "http://music.qq.com/miniportal/static/lyric/87/4944987.xml"
        return "";
    }
}
