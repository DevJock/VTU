//
//  ResultViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 7/30/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController
{
    NSString *selName,*selInt,*selExt,*selTot;
    int numberOfSubjects;
}

@synthesize name,marks,details,subject,table,verdict,sem,total;



- (void)viewWillAppear:(BOOL)animated
{
    numberOfSubjects = (int)[subject count];
   // [table reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    p = [ParsingLibs alloc];
    [table setDelegate:self];
    [table setDataSource:self];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headder = [[UILabel alloc] init];
    headder.numberOfLines = 3;
    headder.backgroundColor = [tableView backgroundColor];
    headder.font = [UIFont boldSystemFontOfSize:15];
    headder.text = [NSString stringWithFormat:@"%@\nSemester: %@",name,sem];
    headder.textAlignment = NSTextAlignmentCenter;
    headder.opaque = false;
    headder.alpha = 0.92;
    return headder;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *footer = [[UILabel alloc] init];
    footer.numberOfLines = 2;
    footer.backgroundColor = [tableView backgroundColor];
    footer.font = [UIFont boldSystemFontOfSize:15];
    footer.text = [NSString stringWithFormat:@"Total: %@\n%@",total,verdict];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.opaque = false;
    footer.alpha = 0.92;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfSubjects;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"customCell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    @try
    {
        UILabel *sname = ((UILabel *)[cell viewWithTag:1]);
        sname.text = [subject objectAtIndex:indexPath.row];
        UILabel *iM = ((UILabel *)[cell viewWithTag:2]);
        iM.text =  [marks objectAtIndex:indexPath.row * 3];
        UILabel *eM = ((UILabel *)[cell viewWithTag:3]);
        eM.text = [marks objectAtIndex:indexPath.row * 3 + 1];
        UILabel *tM = ((UILabel *)[cell viewWithTag:4]);
        tM.text = [marks objectAtIndex:indexPath.row * 3 + 2];
        
        if([[details objectAtIndex:indexPath.row] isEqualToString:@"F"])
        {
            cell.backgroundColor =  [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        }
        else if([[details  objectAtIndex:indexPath.row] isEqualToString:@"P"])
        {
            cell.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"ERROR During Table Processing");
    }
        return cell;
    
}



-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *sname = ((UILabel *)[cell viewWithTag:1]);
    UILabel *iM = ((UILabel *)[cell viewWithTag:2]);
    UILabel *eM = ((UILabel *)[cell viewWithTag:3]);
    UILabel *tM = ((UILabel *)[cell viewWithTag:4]);
    selName = sname.text;
    selInt = iM.text;
    selExt = eM.text;
    selTot = tM.text;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
