//
//  WebViewController.h
//  VTU
//
//  Created by Chiraag Bangera on 12/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong,nonatomic)NSString *htmlData;
@end
