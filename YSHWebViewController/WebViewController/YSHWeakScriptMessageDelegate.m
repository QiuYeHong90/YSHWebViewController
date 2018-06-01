//
//  YSHWeakScriptMessageDelegate.m
//  YSHWebViewController
//
//  Created by 赵 on 2018/6/1.
//  Copyright © 2018年 袁书辉. All rights reserved.
//


#import "YSHWeakScriptMessageDelegate.h"

@implementation YSHWeakScriptMessageDelegate
- (instancetype)initWithDelegate:(id)scriptDelegate{
    
    self= [super init];
    
    if(self) {
        
        _scriptDelegate =scriptDelegate;
        
    }
    
    return self;
    
}

- (void)userContentController:(WKUserContentController*)userContentController didReceiveScriptMessage:(WKScriptMessage*)message{
    
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    
}

@end
