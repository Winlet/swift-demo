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
//        print (NetworkManager().searchSongFromQQMusic(keyword:text as NSString, page: &page, number: &num));
//        print(NetworkManager().searchSongFrom163Music(keyword:text as NSString));
        
//        var page = 1;
//        var num = 20;
//        self.searchSongFromQQMusic(keyword: word, page: &page, number: &num, suc: { (listMusic) in
//            for music in listMusic{
//                print((music as! Music).name!);
//            }
//            suc(listMusic);
//        }) { (error) in
//            err(error);
//        }
        
        self.searchSongFrom163Music(keyword: word, suc: { (listMusic) in
            for music in listMusic{
                print((music as! Music).name!);
            }
            suc(listMusic);
        }) { (error) in
            err(error);
        };
    }

    public func searchSongFromQQMusic(keyword word:String,page pageT:inout Int,number numberT:inout Int ,suc: @escaping (NSMutableArray)->Void , err:@escaping (NSError)->Void) {
        pageT = 1;
        numberT = 20;
       let wordTemp = self.urlEncoded(string: word);
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
        let wordTemp = self.urlEncoded(string: word);
        // https://music.aityp.com/
        let httpRequest = "https://music.aityp.com/search?keywords=\(wordTemp)";
        Alamofire.request(httpRequest).responseJSON{ (response) in
            switch response.result{
            case .success(let dataResult):
             
                let dataDic1 = (dataResult as! NSDictionary)["result"] as! NSDictionary
                let data = [self .dataToDictionary(data: response.data!)];
                var dataD = data.first
                var dataDic : NSDictionary = NSDictionary();
                if dataD != nil {
                    dataDic = dataD!!["result"] as! NSDictionary
                }
                let listMusic = Music().transfrom163Music(dic: dataDic1);
                suc(listMusic);
            case .failure(let error):
               err(error as NSError);
            }
//            switch response.result {
//            case .Success(let data):
//
//            case .Failure(let error):
//
//            }
          
            
        }
//        Alamofire.request(httpRequest).response{ response in
//            let data = [self .dataToDictionary(data: response.data!)];
//            var dataD = data.first
//            var dataDic : NSDictionary = NSDictionary();
//            if dataD != nil {
//                dataDic = dataD!!["data"] as! NSDictionary
//            }
//            let listMusic = Music().transfromQQMusic(dic: dataDic);
//            suc(listMusic);
//        }
    }
    
    func dataToDictionary(data:Data) ->Dictionary<String,Any>?{
        do{
        let json = try JSONSerialization.jsonObject(with:data, options:.mutableContainers)
        let dic = json as! Dictionary<String,Any>
            return dic;
            
        }catch _ {
            print("失败")
            return nil;
        }
    }
    
    //将原始的url编码为合法的url
    func urlEncoded(string:String) -> String {
        let encodeUrlString = string.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded(string:NSString) -> String {
        return string.removingPercentEncoding ?? ""
    }
  


    
}
