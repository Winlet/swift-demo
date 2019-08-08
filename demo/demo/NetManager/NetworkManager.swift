//
//  NetworkManager.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import Alamofire
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
    
    func test(mid:String) -> String {
 
        return "";
    }
}
