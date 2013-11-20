//
//  ATLisenceViewController.m
//  Animetick
//
//  Created by Yuya Yaguchi on 11/19/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import "ATLisenceViewController.h"

@interface ATLisenceViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ATLisenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LibraryLicenses" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = text;
}

@end
