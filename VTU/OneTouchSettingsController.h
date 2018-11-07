//
//  OneTouchSettingsController.h
//  VTU
//
//  Created by Chiraag Bangera on 7/23/15.
//  Copyright (c) 2015 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneTouchSettingsController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;

@end
