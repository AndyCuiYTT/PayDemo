# Pay
> 封装支付宝与微信支付,采用代理的方式接收支付结果.

## 支付宝支付
> #### 调起支付
> ```swift
> 	/// 调起支付宝支付
> 	///
>   /// - Parameters:
>   ///   - orderinfo: 商品信息字符串
    ///   - signedString: 商户信息签名
    ///   - fromScheme: 应用注册scheme
    ///   - resultDic: 支付结果回调
    func pay(_ orderinfo: String, signedString: String, fromScheme: String) -> Void
> ```
> #### 支付结果回调,遵守 AlipayDelegate 协议
> ```swift
> 	/// 支付成功
    func alipaySuccess(_ result: Any) -> Void;
    /// 支付失败
    func alipayFail(_ result: Any) -> Void;
    /// 支付取消
    func alipayCancel(_ result: Any) -> Void;
    /// 其他未知错误
    func alipayUnknownError(_ result: Any) -> Void;
> ```

## 微信支付
> #### 调起支付
> ```swift
> 	/// 微信支付
    ///
    /// - Parameter orderInfo: 支付信息(包含:partnerId,prepayId,package,nonceStr,timeStamp,sign等信息)
    func pay(_ orderInfo: [String : String]) -> Void
> ```
> #### 数据签名(获取签名字符串)
> ```swift
> 	/// 获取签名字符串(MD5 签名)
    ///
    /// - Parameters:
    ///   - orderInfo: 支付信息
    ///   - keyStr: API密钥
    /// - Returns: 签名字符串
    func getSignStr(_ orderInfo: [String : String] ,keyStr: String) -> String
> ```
> #### 支付结果回调,遵守 WeChatPayDelegate 协议
> ```swift
> 	/// 微信未安装
    func WeChatPayWXAppUninstall() -> Void;
    /// 支付成功
    func WeChatPaySuccess() -> Void;
    /// 支付失败
    func WeChatPayFail(errStr: String) -> Void;
    /// 支付取消
    func WeChatPayCancel() -> Void;
> ```
