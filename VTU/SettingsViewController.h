//
//  SettingsViewController.h
//  VTU
//
//  Created by Chiraag Bangera on 7/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <iAd/iAd.h>
@interface SettingsViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,ADBannerViewDelegate>
{
    AppDelegate *appDelegate;
    ParsingLibs *p;
}

@property (strong, nonatomic) IBOutlet UITextField *usnTextField;
- (IBAction)clearData:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *spaceLabel;
@property (strong, nonatomic) ADBannerView *UIiAD;
- (IBAction)setupPush:(id)sender;

@end
