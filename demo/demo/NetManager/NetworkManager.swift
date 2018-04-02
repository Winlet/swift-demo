//
//  NetworkManager.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import Alamofire



class NetworkManager: NSObject {

    public func searchSong(keyword word:NSString,page page:inout Int,number number:inout Int) -> NSString {
        page = 1;
        number = 20;
       let wordTemp = self.urlEncoded(string: word);
        let httpRequest = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.center&searchid=37602803789127241&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=\(page)&n=\(number)&w=\(wordTemp)&g_tk=5381&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0";
        Alamofire.request(httpRequest).response { response in

            let data = [self .dataToDictionary(data: response.data!)];
            let dataD = data.first;
            let dataDic = dataD!!["data"] as? NSDictionary
            let listMusic = Music().transfromQQMusic(dic: dataDic!);

            for music in listMusic{
            print((music as! Music).name!);
            }
        }
//            .responseJSON { response in
//
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)") //具体如何解析json内容可看下方“响应处理”部分
//            }
//        }
        
        return  NSString();
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
    func urlEncoded(string:NSString) -> String {
        let encodeUrlString = string.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded(string:NSString) -> String {
        return string.removingPercentEncoding ?? ""
    }
    
}
