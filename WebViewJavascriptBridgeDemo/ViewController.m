//
//  ViewController.m
//  WebViewJavascriptBridgeDemo
//
//  Created by zj on 2017/5/31.
//  Copyright © 2017年 zj. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController ()<UIWebViewDelegate>
//声明‘WebViewJavasciptBridge’对象为属性
@property (nonatomic, strong) WebViewJavascriptBridge * bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //用UIWebView加载web
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //设置能够进行桥接
    [WebViewJavascriptBridge enableLogging];
    //初始化*WebViewjavascriptBridge实例，设置代理，进行桥接
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge setWebViewDelegate:self];
}

- (void)getValueFromJs
{
    //js给oc传值，‘passValue’为双方自定义的统一方法名；‘data‘为JS传过来的值；’responseCallback‘为OC收到值后个JS返回的回调
    [self.bridge registerHandler:@"passValue" handler:^(id data, WVJBResponseCallback responseCallback) {
        //打印JS传过来的值
        NSLog(@"%@",data);
        
        //返回给JS的回调
        responseCallback(@"收到了");
    }];
}

- (void)passValueToJS
{
    //oc给JS传值，’testJavascriptHnadler‘为双方自定义的统一方法名；data里即为要传过去的值,responseCallback为JS收到数据后给OC的回调
    [self.bridge callHandler:@"nativeCallWeb" data:@{@"年龄":@"20"} responseCallback:^(id responseData) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
