# YSHWebViewController

### YSHWebViewController 的使用 

在项目里直接继承YSHWebViewController 即可，如有里面不符合业务逻辑的可以用子类重写父类方法

### 实现了模仿微信的导航条，导航上面动态添加关闭按钮  、、
### 实现了简单的交互事件
### js代码实现
```
/* 判断是安卓还是ios ,调用的方法要跟ios端和安卓端约定方面名参数*/  
var u = navigator.userAgent, app = navigator.appVersion;  
var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1; //android终端或者uc浏览器  
var isIOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端  
if (isAndroid) {  

window.jsCallOC.postMessage(); 
}  

if (isIOS) {  

window.webkit.messageHandlers.jsCallOC.postMessage({body: '传数据'});

}  

```
### 客户端添加监听

```
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
 

```

####  客户端回调事件

```

//TODO: 点击事件
- (void)tapJavaScrptWithMessage:(WKScriptMessage *)message
{
if ([message.name isEqualToString:@"jsCallOC"]) {
NSLog(@"------%@",message.body);
[self.navigationController popViewControllerAnimated:YES];
}
}


```

