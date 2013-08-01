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
    NSLog(@"here");
    
    //[self connectionSample];
}

- (void)connectionSample
{
    NSString *sessionId = @"N0tPUGM0RUZIYWUxOWlZVkZpY00rZ2x1bVA1U3NuNTQ0bGUrTFoxVk1MKytyK01xalRNRUFRSVNqb2NLRDhjOVlrVGVQZlN0UVpsK1F4NjdiWTRKV24zdHlSazVwN1NEVjhkS3FuQ2xMNGQzTnVpekN1WVIyWjBOaVJiaFBnK2dXRVNBaTAxOVJ3dEFDbnh1WThML2tLbC9SSGEyZ3p3bld3ZURvUE16S1VXdEYydzVqU3QwL2lNMHhrK2xSZVhSaGJmTU5NT09OV2Q1dGlOc01FckNpTzhLMWZNNFpZQ0hCY3dFSlcyalRSejN2QUlRNGoxcDFaVHo1azdnRmhvYUZkYkdMQVVhLzRwWjhSd1ZVeHBTMlFzL0I3RWFBMVhQUjRmL1pvUjVPYllkQ09KZi9pajhmWHJiRmIwdmsrWEVFWktDUzJsVDFZUzh3c2tDMGpYVTcxM05IUmtzWk0xaWFYbGMyc095MHdEeDZXdjNBd2NOcnBhZ3d5Sm8zTzMzQkpzZTNIWFM1SHdtYjlxRlBhdTNnYXFHZklIaU5SM1RGSWwxTFZlZVFuUi9EOUVJN0JDWTB6bXJrb0ZlaUZMeDBoZmJ3NDB4NDl0cGdOL293YjlaVDZhMkpPZU5kcEdzUmcyRGNFNHlaVUtTV3pudDFtZXJtOCtpeUNJc3IxdEJrTk5uZytQUERLa1ZxN3JkeVh1QkszaytjNXFScHlQYk5GQmEwRFJYQ3NNPS0tTkVGamlDbFpPbndrV0ZFeHppcGxjZz09--bc8c4aaa5928f3d708fc1f8636b9a7fe3c32caf3";
    NSURL *url = [NSURL URLWithString:@"http://kazz187:h8xelpr1@dev.animetick.net/ticket/list/0.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    
    // NSHTTPCookieを作成し、それを配列形式として、
    // requestHeaderFieldsWithCookiesを使って、HTTPヘッダへ設定する
    NSDictionary *cookieProperties = @{NSHTTPCookieName: @"_animetick_session",
                                       NSHTTPCookieValue: sessionId,
                                       NSHTTPCookieDomain: @"dev.animetick.net",
                                       NSHTTPCookiePath: @"\\",
                                       NSHTTPCookieExpires: @0};
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
    NSDictionary *header = [NSHTTPCookie requestHeaderFieldsWithCookies:@[cookie]];
    [request setAllHTTPHeaderFields:header];
    
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSArray *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", result);
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    
    return YES;
}

@end
