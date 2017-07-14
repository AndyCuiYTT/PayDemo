//
//  AlipayHelper.swift
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
 *  note: swift 集成 ailpay 需要建立桥接文件添加 '#import <AlipaySDK/AlipaySDK.h>',如果 Unknown type name 'UIWindow' 或 property with 'weak' attribute must be of object type 错误请添加 '#import <UIKit/UIKit.h>',务必添加在 '#import <AlipaySDK/AlipaySDK.h>' 之前
 *
 *  签名过程: https://docs.open.alipay.com/291/106118
 *
 *  签名算法参考: https://github.com/TakeScoop/SwiftyRSA
 * 
 *
 */


protocol AlipayDelegate: class {
    
    /// 支付成功
    func alipaySuccess(_ result: Any) -> Void;
    
    /// 支付失败
    func alipayFail(_ result: Any) -> Void;
    
    /// 支付取消
    func alipayCancel(_ result: Any) -> Void;
    
    /// 其他未知错误
    func alipayUnknownError(_ result: Any) -> Void;
    
}



import UIKit

class AlipayHelper: NSObject {
    
    private weak var delegate: AlipayDelegate?
    
    init(_ delegate: AlipayDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    
    /// 调起支付宝支付
    ///
    /// - Parameters:
    ///   - orderinfo: 商品信息字符串
    ///   - signedString: 商户信息签名
    ///   - fromScheme: 应用注册scheme
    ///   - resultDic: 支付结果回调
    func pay(_ orderinfo: String, signedString: String, fromScheme: String) -> Void {
        let payOrder = "\(orderinfo)&sign=\(signedString)"
        AlipaySDK.defaultService().payOrder(payOrder, fromScheme: fromScheme){ (result) in
            
            switch result?["code"] as! String {
            case "9000":
                self.delegate?.alipaySuccess(result!)
            case "4000":
                self.delegate?.alipayFail(result!)
            case "6001":
                self.delegate?.alipayCancel(result!)
            default:
                self.delegate?.alipayUnknownError(result!)
            }
        }
    }
    
    
    
    
    

}
