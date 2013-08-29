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
    
    self.navigationItem.title = @"ログイン";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ATAnimetickURLString, @"/app/login"];
    NSURL *url = [NSURL URLWithString:urlString];
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
        NSString *sessionId
          = [webView stringByEvaluatingJavaScriptFromString:@"animetick.app.getSesssionForNativeApp();"];
        NSString *csrfToken
          = [webView stringByEvaluatingJavaScriptFromString:@"animetick.app.getCSRFTokenForNativeApp();"];
        [[ATServiceLocator sharedLocator].auth setSessionId:sessionId
                                                  csrfToken:csrfToken];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    return YES;
}

@end
