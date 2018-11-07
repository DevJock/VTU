//
//  WebViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 12/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView,htmlData;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [webView loadHTMLString:htmlData baseURL:nil];
    NSLog(@"Loading Captcha View");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
