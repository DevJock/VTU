//
//  OneTouchViewController.h
//  VTU
//
//  Created by Chiraag Bangera on 7/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface OneTouchViewController : UIViewController<ADBannerViewDelegate>
{
    AppDelegate *appDelegate;
    ParsingLibs *p;
}
@property (strong, nonatomic) IBOutlet UILabel *bigText;
- (IBAction)checkButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UILabel *usnText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) ADBannerView *UIiAD;

@end
