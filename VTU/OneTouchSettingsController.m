//
//  OneTouchSettingsController.m
//  VTU
//
//  Created by Chiraag Bangera on 7/23/15.
//  Copyright (c) 2015 Chiraag Bangera. All rights reserved.
//

#import "OneTouchSettingsController.h"

@interface OneTouchSettingsController ()

@end

@implementation OneTouchSettingsController

@synthesize table;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headder = [[UILabel alloc] init];
    headder.numberOfLines = 3;
    headder.backgroundColor = [UIColor grayColor];
    headder.textAlignment = NSTextAlignmentCenter;
    headder.text = @"One Touch Comparitive Settings";
    return headder;
}



-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    @try
    {
        UILabel *number = ((UILabel *)[cell viewWithTag:5]);
        number.text = [NSString stringWithFormat:@"%d.",(int)indexPath.row ];
        UILabel *name = ((UILabel *)[cell viewWithTag:6]);
        name.text = [NSString stringWithFormat:@"%@",@"sad"];
    }
    @catch(NSException *e)
    {
        NSLog(@"ERROR During Table Processing");
    }
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        @try
        {
            [table beginUpdates];
            
            [table endUpdates];
        }
        @catch(NSException *e)
        {
            NSLog(@"ERROR During file Deletion");
        }
    }
}




@end
