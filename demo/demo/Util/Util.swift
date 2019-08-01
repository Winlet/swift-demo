//
//  Util.swift
//  demo
//
//  Created by uinpay on 2019/8/1.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit

class Util: NSObject {
    class func dataToDictionary(data:Data) ->Dictionary<String,Any>?{
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
    class func urlEncoded(string:String) -> String {
        let encodeUrlString = string.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    class func urlDecoded(string:NSString) -> String {
        return string.removingPercentEncoding ?? ""
    }
}
