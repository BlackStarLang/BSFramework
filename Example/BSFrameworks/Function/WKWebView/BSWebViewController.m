//
//  BSWebViewController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/8.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSWebViewController.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import "BSFunctionModel.h"



@interface BSWebViewController ()

@property (nonatomic ,strong) WKWebView *webView;


@end

@implementation BSWebViewController



-(void)dealloc{
    NSLog(@"=======");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];

}


#pragma mark autoreleasepool 测试




#pragma mark - initWebView

-(void)initWebView{
    
    self.view.backgroundColor = [UIColor grayColor];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}


@end
