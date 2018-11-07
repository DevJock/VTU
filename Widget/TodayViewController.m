//
//  TodayViewController.m
//  Widget
//
//  Created by Chiraag Bangera on 11/2/15.
//  Copyright © 2015 Chiraag Bangera. All rights reserved.
//

#import "TodayViewController.h"
#import "ParsingLibs.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

@synthesize usnLabel,semLabel,totalMarksLabel,percentLabel,resultLabel;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 50);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
}

@end