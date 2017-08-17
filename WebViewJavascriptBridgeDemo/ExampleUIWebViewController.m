//
//  ExampleUIWebViewController.m
//  WebViewJavascriptBridgeDemo
//
//  Created by zj on 2017/5/31.
//  Copyright © 2017年 zj. All rights reserved.
//

#import "ExampleUIWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ExampleUIWebViewController ()

@property (nonatomic, strong) WebViewJavascriptBridge * bridge;

@end

@implementation ExampleUIWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.bridge) {return;}
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge setWebViewDelegate: self];
    
    //js给oc传值，‘passValue’为双方自定义的统一方法名；‘data‘为JS传过来的值；’responseCallback‘为OC收到值后个JS返回的回调

    [self.bridge registerHandler:@"webCallNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"webCallNative called:%@",data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    ////oc给JS传值，’testJavascriptHnadler‘为双方自定义的统一方法名；data里即为要传过去的值,responseCallback为JS收到数据后给OC的回调
    [self.bridge callHandler:@"nativeCallWeb" data:@{@"foo" : @"before ready"} responseCallback:^(id responseData) {
        NSLog(@"-----------");
        NSLog(@"%@",responseData);
    }];

}

- (void)renderButtons:(UIWebView *)webView
{
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(0, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(90, 400, 100, 35);
    reloadButton.titleLabel.font = font;
    
    UIButton* safetyTimeoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [safetyTimeoutButton setTitle:@"Disable safety timeout" forState:UIControlStateNormal];
    [safetyTimeoutButton addTarget:self action:@selector(disableSafetyTimeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:safetyTimeoutButton aboveSubview:webView];
    safetyTimeoutButton.frame = CGRectMake(190, 400, 120, 35);
    safetyTimeoutButton.titleLabel.font = font;

}

- (void)disableSafetyTimeout
{
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}

- (void)callHandler:(UIButton *)button
{
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [self.bridge callHandler:@"nativeCallWeb" data:data responseCallback:^(id responseData) {
        NSLog(@"testJavascriptHandler responded:%@",responseData);
    }];
}

- (void)loadExamplePage:(UIWebView *)webView
{
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test-native" ofType:@"html"];
    NSString * appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL * baseUrl = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseUrl];
}


@end
