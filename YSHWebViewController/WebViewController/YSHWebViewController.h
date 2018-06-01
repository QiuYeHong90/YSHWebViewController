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



/**
 加载的url字符串
 */
@property (nonatomic,copy)   NSString * urlStr ;


/**
 添加js回调事件
 */
-(void)addJSCallBlock;
/**
 页面交互点击事件
 */
- (void)tapJavaScrptWithMessage:(WKScriptMessage *)message;
@end
