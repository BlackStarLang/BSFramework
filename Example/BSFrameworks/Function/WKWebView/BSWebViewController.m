//
//  BSWebViewController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/8.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSWebViewController.h"
#import <WebKit/WebKit.h>
//#import <UIView+BSView.h>

@interface BSWebViewController ()

@property (nonatomic ,strong) WKWebView *webView;
//@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation BSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];

    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}



@end
