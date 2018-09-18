//
//  XKRMStoreHelper.m
//  PinShangHome
//
//  Created by Nicholas on 2017/9/15.
//  Copyright © 2017年 haha. All rights reserved.
//

#import "XKRMStoreHelper.h"
#import "RMStore.h"

#define XKWeakSelf __weak typeof(self)weakSelf = self;

@interface XKRMStoreHelper ()

@property (nonatomic, strong) NSArray *invalidProducts;
///iap
@property (nonatomic, strong) RMStore *rmStore;

@property (nonatomic, assign) BOOL canBuy;

@end

@implementation XKRMStoreHelper

- (instancetype)init {
    if (self = [super init]) {
        self.rmStore = [RMStore defaultStore];
    }
    return self;
}
#pragma mark 设置产品
- (void)setProducts:(NSArray *)products {
    _products = products;
    [self xk_startReqeustingProducts:products succ:nil fail:nil];
}

#pragma mark 判断是否能进行内购
+ (BOOL)xk_canMakePayment {
    return [RMStore canMakePayments];
}
#pragma mark 判断是否能购买
- (BOOL)xk_canMakeDeal {
    return self.canBuy;
}
#pragma mark  购买商品
- (void)xk_startBuyingWithProductID:(NSString *)productID succ:(void (^)(void))successful fail:(void (^)(NSError *))fail {
    
    XKWeakSelf
    [self.rmStore addPayment:productID success:^(SKPaymentTransaction *transaction) {
        
        if (successful) successful();
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        
        if (fail) fail(error);
        weakSelf.canBuy = NO;
    }];
}

#pragma mark 请求商品
- (void)xk_startReqeustingProducts:(NSArray *)productIDs succ:(void (^)(NSArray *, NSArray *))successful fail:(void (^)(NSError *))fail {
    
    _products = productIDs;
    XKWeakSelf
    [self.rmStore requestProducts:[NSSet setWithArray:productIDs] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        if (products.count > 0) {
            weakSelf.canBuy = YES;
            weakSelf.invalidProducts = invalidProductIdentifiers;
            if (successful) successful(products,invalidProductIdentifiers);
        }
        
    } failure:^(NSError *error) {
        if (fail) fail(error);
        weakSelf.canBuy = NO;
    }];
}
#pragma mark 获取收据
+ (NSURL *)xk_getReceiptURL {
    return [RMStore receiptURL];
}
#pragma mark 将收据base64
+ (NSString *)xk_getReceiptBase64String {
    
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receiptBase64Str = [receiptData base64EncodedStringWithOptions:0];
    
//    NSLog(@"-----> %@",[[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding]);
//    NSLog(@"url-> %@",receiptURL);
//    NSLog(@"data-> %@",receiptData);
//    NSLog(@"dict-> %@",[NSDictionary dictionaryWithContentsOfURL:receiptURL]);
    
    return receiptBase64Str;
}

#pragma mark 内购验证
- (void)_validateReceipt {
    
    NSString *urlStr = @"https://sandbox.itunes.apple.com/verifyReceipt";
    //    NSDictionary *para = @{
    //                           @"receipt-data":[XKRMStoreHelper xk_getReceiptBase64String]
    //                           };
    
    
    //    NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]]; // Sent to the server by the device
    
    // Create the JSON object that describes the request
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [XKRMStoreHelper xk_getReceiptBase64String]
                                      };
    //    NSLog(@"%@",[[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] encoding:NSUTF8StringEncoding]);
    
    //    [XKRMStoreHelper xk_getReceiptBase64String];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    //
    if (!requestData) { /* ... Handle error ... */
        
    }
    
    // Create a POST request with the receipt data.
    //    NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   /* ... Handle error ... */
                                   NSLog(@"%@",connectionError);
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) { /* ... Handle error ...*/
                                       NSLog(@"%@",error);
                                   }
                                   else {
                                       NSLog(@"%@",jsonResponse);
                                   }
                                   /* ... Send a response back to the device ... */
                               }
                           }];
    
    
}

@end
