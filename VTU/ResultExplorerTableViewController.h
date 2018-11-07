//
//  ResultExplorerTableViewController.h
//  VTU
//
//  Created by Chiraag Bangera on 8/10/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <iAd/iAd.h>

@interface ResultExplorerTableViewController : UITableViewController<ADBannerViewDelegate>
{
	NSMutableArray *files;
}
@property (nonatomic, retain) NSMutableArray *files;
@property (strong, nonatomic) ADBannerView *UIiAD;
@end
