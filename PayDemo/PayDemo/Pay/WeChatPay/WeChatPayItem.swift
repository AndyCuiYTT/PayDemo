//
//  WeChatPayItem.swift
//  PayDemo
//
//  Created by Andy on 2017/7/17.
//  Copyright © 2017年 AndyCuiYTT. All rights reserved.
//

import UIKit

// MARK: 签名辅助方法

/// 字符串 MD5加密
///
/// - Parameter str: 要加密字符串
/// - Returns: 加密后字符串
fileprivate func MD5(_ str: String) -> String {
    let cStr = str.cString(using: .utf8)
    let strLen = CUnsignedInt(str.lengthOfBytes(using: .utf8))
    let result = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5(cStr, strLen, result)
    let MD5Str = NSMutableString()
    for i in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
        MD5Str.appendFormat("%02x", result[i])
    }
    result.deinitialize()
    return MD5Str as String
    
}

/// 获取签名字符串(MD5 签名)
///
/// - Parameters:
///   - orderInfo: 支付信息
///   - keyStr: API密钥
/// - Returns: 签名字符串
fileprivate func getSignStr(_ orderInfo: [String : String] ,keyStr: String) -> String {
    var signStr = String()
    let keys = orderInfo.keys.sorted()
    for key in keys {
        if key != "sign" && !(orderInfo[key]?.isEmpty)!{
            signStr.append("\(key)=\(orderInfo[key]!)&")
        }
    }
    signStr.append("key=\(keyStr)")
    print(signStr)
    return MD5(signStr).uppercased()
}

class WeChatPayItem: NSObject {
    
    private let payKeyStr = ""
    
    // 62
    private let nonce: [String] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",]
    
    init(appid: String, partnerid: String, prepayid: String) {
        super.init()
        self.appid = appid
        self.partnerid = partnerid
        self.prepayid = prepayid
    }
    
    var appid: String!
    var partnerid: String!
    var prepayid: String!
    var package: String! {
        return "Sign=WXPay"
    }
    var noncestr: String! {
        var str: String = String()
        for _ in 0 ..< 32 {
            str.append(nonce[Int(arc4random() % 62)])
        }
        return str
    }
    
    var timestamp: String! {
        return Int(Date().timeIntervalSince1970).description
    }
    
    func getSignDic() -> [String : String] {
        var dic: [String : String] = ["appid" : appid, "partnerid" : partnerid, "prepayid" : prepayid, "package" : package, "noncestr" : noncestr, "timestamp" : timestamp]
        dic["sign"] = getSignStr(dic, keyStr: payKeyStr)
        return dic
    }
    
}



