//
//  YSHWebViewController.m
//  YSHWebViewController
//
//  Created by 赵 on 2018/6/1.
//  Copyright © 2018年 袁书辉. All rights reserved.
//

#import "YSHWeakScriptMessageDelegate.h"
//系统版本判断
#define SystemVersion [[UIDevice currentDevice].systemVersion intValue]

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X (IS_IPHONE && [[UIScreen mainScreen]bounds].size.height == 812.0)

#define YSHLAZY(a,b) a==nil ? b:a

#import "YSHWebViewController.h"



@interface YSHWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong) WKWebView * wkWebView;
/**1.添加UIProgressView属性 */
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,strong) WKWebViewConfiguration *wkConfig;

/**
 返回按钮
 */
@property (nonatomic)UIBarButtonItem* customBackBarItem;

/**
 关闭按钮
 */
@property (nonatomic)UIBarButtonItem* closeButtonItem;



/**
 图片资源
 */
@property (nonatomic,strong) NSBundle *myBoundle;
@end

@implementation YSHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigationItems];
    [self ysh_loadUI];
    [self addJSCallBlock];
}

/**
 动态更新导航上面的按钮
 */
-(void)updateNavigationItems{
    if (self.wkWebView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        [self.navigationItem setLeftBarButtonItems:@[self.closeButtonItem] animated:NO];
        
        //弃用customBackBarItem，使用原生backButtonItem
                [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
    }else{
         [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem] animated:NO];
    }
}
/**
 TODO:初始化UI
 */

-(void)ysh_loadUI
{
    //初始化progressView
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,[self navHeight], self.view.frame.size.width, 2)];
    self.progressView.progressTintColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
//    http://www.qiurongkj.com/nvolvingCall/Customer_service.html
    
    /*
     *3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
     */
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self loadWebView];
    
    
    [self.view addSubview:self.wkWebView];
    
    
    
    
    
    
}


/**
 添加js回调事件
 */
-(void)addJSCallBlock
{
   
    
    WKUserContentController *userCC = self.wkConfig.userContentController;
    //JS调用OC 添加处理脚本
    YSHWeakScriptMessageDelegate * delete = [[YSHWeakScriptMessageDelegate  alloc]initWithDelegate:self];
//    self.modelDelegate = delete;
    [userCC addScriptMessageHandler:delete name:@"jsCallOC"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    self.wkWebView.navigationDelegate = nil;
   
}

-(void)loadWebView
{
//    self.urlStr = @"http://www.qiurongkj.com/Luckdraw/index.html?QB=10";
//    self.urlStr = @"https://www.baidu.com";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    request.timeoutInterval = 15.0f;
    [self.wkWebView loadRequest:request];
}

-(void)dealloc
{
    NSLog(@"释放了");
}

#pragma mark ------------------- 导航高度
-(CGFloat)navHeight
{
    return 44+[self statsHeight];
}

-(CGFloat)statsHeight
{
    if (IS_IPHONE_X) {
        return 44;
    }
    return 20;
}
#pragma mark - events handler  点击事件
-(void)customBackItemClicked{
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------- 懒加载
-(NSBundle *)myBoundle
{
    if (!_myBoundle) {
        _myBoundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YSHWebViewController" ofType:@"bundle"]];
        if (nil == _myBoundle) { // Empty description resource file in `PYSearch.framework`.
            _myBoundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"YSHWebViewController" ofType:@"bundle"]];
        }
    }
    
    return _myBoundle;
}

-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage =[[self ysh_imageNamed:@"backItemImage"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[self ysh_imageNamed:@"backItemImage-hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,[self navHeight], self.view.frame.size.width,[UIScreen mainScreen].bounds.size.height-[self navHeight]) configuration:self.wkConfig];
        
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        [_wkWebView.configuration.userContentController addUserScript:noneSelectScript];
        
        
        
        
        
    }
    return _wkWebView;
}
- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        if (SystemVersion >= 9.0) {
            _wkConfig.allowsInlineMediaPlayback = YES;
            _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        }
    }
    return _wkConfig;
}


#pragma mark - 监听方法中获取网页加载的进度
/* *4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
        if (self.wkWebView.estimatedProgress < 1.0){
            return;
        }
        //        //完全加载后获取webview的高度
        
        NSString *js = @"document.body.scrollHeight";
        [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable height, NSError * _Nullable error) {
            
            
            
        }];
    } else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView) {
            self.title = self.wkWebView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    NSLog(@"------------");
    [self updateNavigationItems];
}


#pragma mark - WKWKNavigationDelegate Methods
/**5.在WKWebViewd的代理中展示进度条，加载完成后隐藏进度条*/
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    
    //    [self showLoadingHUD];
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    [self updateNavigationItems];
}



/**
 //加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载完成");
    
     [self updateNavigationItems];
    
    
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求超时请重试" preferredStyle:1];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.wkWebView reload];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    //加载失败同样需要隐藏progressView
    //    [self hideLoadingHUD];
    self.progressView.hidden = YES;
    [self updateNavigationItems];
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    NSLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
    [self updateNavigationItems];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"回到主线程");
        NSDictionary * dict = message.body;
        
        NSLog(@"回到主线程==%@",dict);
        
        [self tapJavaScrptWithMessage:message];
        
    });
}


//TODO: 点击事件
- (void)tapJavaScrptWithMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"jsCallOC"]) {
        NSLog(@"------%@",message.body);
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)ysh_imageNamed:(NSString *)name
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIImage * image = [self ysh_getImageViewWithScale:scale name:name];
    
    if (image==nil) {
        image = [self ysh_getImageViewWithScale:2 name:name];
    }
    
    return image;
}


-(UIImage *)ysh_getImageViewWithScale:(CGFloat)scale name:(NSString *)name
{
    name = 3.0 == scale ? [NSString stringWithFormat:@"%@@3x.png", name] : [NSString stringWithFormat:@"%@@2x.png", name];
    UIImage *image = [UIImage imageWithContentsOfFile:[[self.myBoundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"img/%@",name]]];
    
    return image;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
