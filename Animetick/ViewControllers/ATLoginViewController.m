//
//  ATLoginViewController.m
//  Animetick
//
//  Created by Kazuki Akamine on 2013/06/30.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATLoginViewController.h"
#import "ATAuth.h"

@interface ATLoginViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ATLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://kazz187:h8xelpr1@dev.animetick.net/app/login"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"webview delegate OK %@", [[request URL] absoluteString]);
    
    // example: animetick://login_session/
    if ([[[request URL] scheme] isEqualToString:@"animetick"]
        && [[[request URL] host] isEqualToString:@"login_session"]) {
        NSString *session
          = [webView stringByEvaluatingJavaScriptFromString:@"animetick.app.getSesssionForNativeApp();"];
        APPDELEGATE.auth.sessionId = session;
        NSLog(@"%@", session);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    return YES;
}

@end
