//
//  FirstViewController.h
//  VTU
//
//  Created by Chiraag Bangera on 7/30/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OneTouchViewController.h"
#import "Reachability.h"
#import <iAd/iAd.h>

@interface FirstViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,ADBannerViewDelegate>
{
    IBOutlet UITextField *usnTextField;
    ParsingLibs *p;
    AppDelegate *appDelegate;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@property (strong, nonatomic) IBOutlet UIButton *moreb;

- (IBAction)moreButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
- (IBAction)fetchButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *usnTextField;
@property (strong, nonatomic) IBOutlet UIButton *fetchButton;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) IBOutlet UILabel *connectionText;
@property (strong, nonatomic) ADBannerView *UIiAD;

@end
