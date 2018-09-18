//
//  XKRMStoreHelper.h
//  PinShangHome
//
//  Created by Nicholas on 2017/9/15.
//  Copyright © 2017年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRMStoreHelper : NSObject

///产品的id，赋值后会自动执行 - (void)xk_startReqeustingProducts:(NSArray *)productIDs successful:(void(^)())successful failed:(void(^)())failed
@property (nonatomic, strong) NSArray <NSString *>*products;

///判断是否支持内购
+ (BOOL)xk_canMakePayment;
///判断是否能购买商品
- (BOOL)xk_canMakeDeal;
///用于获取收据
+ (NSURL *)xk_getReceiptURL;
///将收据进行base64
+ (NSString *)xk_getReceiptBase64String;
///开始购买商品
- (void)xk_startBuyingWithProductID:(NSString *)productID succ:(void(^)(void))successful fail:(void(^)(NSError *error))fail;

///开始请求商品
- (void)xk_startReqeustingProducts:(NSArray *)productIDs succ:(void(^)(NSArray *products, NSArray *invalidProductIdentifiers))successful fail:(void(^)(NSError *error))fail;

@end
