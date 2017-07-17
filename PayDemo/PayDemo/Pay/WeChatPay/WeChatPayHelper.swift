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
 *  签名过程: https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
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
    
    
    
    private weak var delegate: WeChatPayDelegate?
    
    
    override init() {
        super.init()
    }
    
    
    init(_ delegate: WeChatPayDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    
    /// 微信支付
    ///
    /// - Parameter orderInfo: 支付信息(包含:partnerId,prepayId,package,nonceStr,timeStamp,sign等信息)
    func pay(_ orderInfo: [String : String]) -> Void {
        
        if WXApi.isWXAppInstalled() {
            let request = PayReq()
            request.partnerId = orderInfo["partnerId"]
            request.prepayId = orderInfo["prepayId"]
            request.package = orderInfo["package"]
            request.nonceStr = orderInfo["nonceStr"]
            request.timeStamp = UInt32(orderInfo["timeStamp"]!)!
            request.sign = orderInfo["sign"]
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
    
    
        
}


