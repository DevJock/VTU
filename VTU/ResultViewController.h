//
//  ResultViewController.h
//  VTU
//
//  Created by Chiraag Bangera on 7/30/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ResultViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *appDelegate;
    ParsingLibs *p;
    NSString *name,*verdict,*sem,*total;
    NSMutableArray *subject,*marks,*details;
    IBOutlet UITableView *table;
}

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *verdict;
@property (nonatomic,strong) NSString *sem;
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) NSMutableArray *subject;
@property (nonatomic,strong) NSMutableArray *marks;
@property (nonatomic,strong) NSMutableArray *details;

@property (strong, nonatomic) IBOutlet UITableView *table;




@end
