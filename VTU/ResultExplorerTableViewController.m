//
//  ResultExplorerTableViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 8/10/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "ResultExplorerTableViewController.h"
#import "LoaderViewController.h"
#import "ParsingLibs.h"
#import "ResultViewController.h"

@interface ResultExplorerTableViewController ()

@end

@implementation ResultExplorerTableViewController
{
    ParsingLibs *pl;
    NSMutableDictionary *details;
    AppDelegate *appDelegate;
}

@synthesize files;

#pragma mark -
#pragma mark View lifecycle



- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(void) viewWillDisappear:(BOOL)animated{
    _UIiAD.delegate = nil;
    _UIiAD=nil;
    [_UIiAD removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self scrollViewDidScroll:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //refresh banner frame during the scrolling
    CGRect bannerFrame = _UIiAD.frame;
    bannerFrame.origin.y = self.view.frame.size.height - 50 + self.tableView.contentOffset.y;
    _UIiAD.frame = bannerFrame;
}


-(void)viewWillAppear:(BOOL)animated
{
    pl = [[ParsingLibs alloc] init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.files = [pl fileFormatter];
    _UIiAD = [[self appdelegate] UIiAD];
    _UIiAD.delegate = self;
    [_UIiAD setFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 44,320,50)];
    [self.view addSubview:_UIiAD];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [files count];
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headder = [[UILabel alloc] init];
    headder.numberOfLines = 3;
    headder.backgroundColor = [UIColor grayColor];
    headder.textAlignment = NSTextAlignmentCenter;
    NSString *name = [NSString stringWithFormat:@"%@\n%@\n Aggregate: %@", [[files objectAtIndex:section] objectForKey:@"name"],[[files objectAtIndex:section] objectForKey:@"usn"],[pl aggregateForUSN:[files objectAtIndex:section]]];
    headder.text = name;
    return headder;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pl numberOfSem:[ files objectAtIndex:section]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *sem = ((UILabel *)[cell viewWithTag:10]);
    sem.text = [NSString stringWithFormat:@"Semester: %d",(int)indexPath.row + 1];
    
    UILabel *result = ((UILabel *)[cell viewWithTag:11]);
    result.text = [[[files objectAtIndex:indexPath.section] objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row + 1]] objectForKey:@"grade"];
    
    UILabel *percentage = ((UILabel *)[cell viewWithTag:12]);
    percentage.text = [[[files objectAtIndex:indexPath.section] objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row + 1]] objectForKey:@"score"];
    
    if( [((UILabel *)[cell viewWithTag:11]).text isEqualToString:@"FIRST CLASS"] || [((UILabel *)[cell viewWithTag:11]).text isEqualToString:@"FIRST CLASS WITH DISTICTION"])
    {
        cell.backgroundColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:0.6];
    }
    
    else if( [((UILabel *)[cell viewWithTag:11]).text isEqualToString:@"SECOND CLASS"])
    {
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:0.6];
    }

    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:0.6];
    }
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoaderViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"loaderView"];
    [add setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:add animated:YES completion:^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [pl resultManager:[[files objectAtIndex:indexPath.section] objectForKey:@"usn"] and:[NSString stringWithFormat:@"%d",(int)indexPath.row + 1]];
                if([appDelegate.resultData isEqualToString:@"DATA"])
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        NSLog(@"Hiding Loader");
                        [self performSegueWithIdentifier:@"ex1" sender:self];
                    }];
                }
            });
        });
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ex1"])
    {
        ResultViewController  *nextVC = (ResultViewController *)[segue destinationViewController];
        nextVC.name =  [NSString stringWithString:appDelegate.name];
        nextVC.subject = [[NSMutableArray alloc] initWithArray:[appDelegate subjects]];
        nextVC.marks = [[NSMutableArray alloc] initWithArray:[appDelegate marks]];
        nextVC.details = [[NSMutableArray alloc] initWithArray:[appDelegate details]];
        nextVC.sem = [NSString stringWithString:appDelegate.sem];
        nextVC.total = [NSString stringWithString:appDelegate.totalMarks];
        nextVC.verdict = [NSString stringWithString:appDelegate.verdict];
    }
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //   NSLog(@"ads loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:1];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //  NSLog(@"ads not loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:0];
    [UIView commitAnimations];
}


@end
