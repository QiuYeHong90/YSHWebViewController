//
//  YSHWebViewController.h
//  YSHWebViewController
//
//  Created by 赵 on 2018/6/1.
//  Copyright © 2018年 袁书辉. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>

@interface YSHWebViewController : UIViewController



@property (nonatomic,copy)  NSString * urlStr ;



/**
 页面交互点击事件
 */
- (void)tapJavaScrptWithMessage:(WKScriptMessage *)message;
@end
