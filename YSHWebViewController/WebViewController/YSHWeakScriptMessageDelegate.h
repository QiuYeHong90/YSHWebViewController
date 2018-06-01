//
//  YSHWeakScriptMessageDelegate.h
//  YSHWebViewController
//
//  Created by 赵 on 2018/6/1.
//  Copyright © 2018年 袁书辉. All rights reserved.
//
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@interface YSHWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property(nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id)scriptDelegate;
@end
