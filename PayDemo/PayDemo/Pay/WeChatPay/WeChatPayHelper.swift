//
//  WeChatPayHelper.swift
//  PayDemo
//
//  Created by Andy on 2017/7/14.
//  Copyright © 2017年 AndyCuiYTT. All rights reserved.
//

/**
 *  author: AndyCUi
 *
 *  date: 2017-7-14
 *
 *  description: 封装支付方法,支付结果通过代理回调处理.
 *
 *  note: 如果需要使用 cocopods 导入,在 Podfile 添加 pod 'WechatOpenSDK'
 *
 */


import UIKit

protocol WeChatPayDelegate : class{
    
    /// 微信未安装
    func WeChatPayWXAppUninstall() -> Void;
    
    /// 支付成功
    func WeChatPaySuccess() -> Void;
    
    /// 支付失败
    func WeChatPayFail(errStr: String) -> Void;
    
    /// 支付取消
    func WeChatPayCancel() -> Void;
}


class WeChatPayHelper: NSObject, WXApiDelegate {
    
    private let payKeyStr = ""
    
    private weak var delegate: WeChatPayDelegate?
    
    
    override init() {
        super.init()
    }
    
    
    init(_ delegate: WeChatPayDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func pay(_ orderInfo: [String : String], isSigned: Bool = true) -> Void {
        
        if WXApi.isWXAppInstalled() {
            let request = PayReq()
            request.partnerId = orderInfo["partnerId"]
            request.prepayId = orderInfo["prepayId"]
            request.package = orderInfo["package"]
            request.nonceStr = orderInfo["nonceStr"]
            request.timeStamp = UInt32(orderInfo["timeStamp"]!)!
            
            if isSigned {
                request.sign = orderInfo["sign"]
            }else {
                request.sign = self.getSignStr(orderInfo, keyStr: payKeyStr)
            }
            
            
            WXApi.send(request)
        }else {
            delegate?.WeChatPayWXAppUninstall()
        }
    }
    
    
    func onResp(_ resp: BaseResp!) {
        if let response = resp as? PayResp {
            switch response.errCode {
            case WXSuccess.rawValue:
                delegate?.WeChatPaySuccess()
            case WXErrCodeUserCancel.rawValue:
                delegate?.WeChatPayCancel()
            default:
                delegate?.WeChatPayFail(errStr: response.errStr)
            }
        }
    }
    
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    
    // MARK: 签名辅助方法
    
    /// 字符串 MD5加密
    ///
    /// - Parameter str: 要加密字符串
    /// - Returns: 加密后字符串
    func MD5(_ str: String) -> String {
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
    func getSignStr(_ orderInfo: [String : String] ,keyStr: String) -> String {
        var signStr = String()
        let keys = orderInfo.keys.sorted()
        for key in keys {
            if key != "sign" && !(orderInfo[key]?.isEmpty)!{
                signStr.append("\(key)=\(orderInfo[key]!)&")
            }
        }
        signStr.append("key=\(keyStr)")
        print(signStr)
        return self.MD5(signStr).uppercased()
    }
    
}


