//
//  OneTouchViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 7/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "OneTouchViewController.h"
#import "WebViewController.h"
#import "LoaderViewController.h"

@interface OneTouchViewController ()

@end

@implementation OneTouchViewController
{
    WebViewController *wvc;
}

@synthesize bigText,checkButton,usnText,activity;


- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) viewWillAppear:(BOOL)animated{
    _UIiAD = [[self appdelegate] UIiAD];
    _UIiAD.delegate = self;
   [_UIiAD setFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 100,320,50)];
    [self.view addSubview:_UIiAD];
}

-(void) viewWillDisappear:(BOOL)animated{
    _UIiAD.delegate = nil;
    _UIiAD=nil;
    [_UIiAD removeFromSuperview];
}


-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"ads loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:1];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"ads not loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:0];
    [UIView commitAnimations];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    p = [ParsingLibs alloc];
    appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
 //   if([p fileCheck:@"USN_Data.dat"])
    appDelegate.qUSN = [p readStringFromFile:@"USN_Data.dat"];
    usnText.text = appDelegate.qUSN;
    if([appDelegate.qUSN  length] >= 10)
        checkButton.enabled = true;
    else
        checkButton.enabled = false;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)start
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoaderViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"loaderView"];
    [add setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:add animated:YES completion:^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            [p resultManager:appDelegate.qUSN and:@"0"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(appDelegate.captcha)
                {
                    wvc = [[WebViewController alloc] init];
                    [self presentViewController:wvc animated:YES completion:nil];
                }
                else
                    if([appDelegate.resultData isEqualToString:@"DATA"])
                    {
                        for(int i=0;i<[appDelegate.details count];i++)
                        {
                            if([[appDelegate.details objectAtIndex:i] isEqualToString:@"F"] || [[appDelegate.details objectAtIndex:i] isEqualToString:@"A"] )
                            {
                                appDelegate.status = @"F";
                                break;
                            }
                            else
                            {
                                appDelegate.status = @"P";
                            }
                        }
                        [self dismissViewControllerAnimated:YES completion:^{
                            NSLog(@"Hiding Loader and Loading View");
                        }];
                        bigText.text = appDelegate.status;
                        if([bigText.text isEqualToString:@"P"])
                            self.view.backgroundColor = [UIColor greenColor];
                        else
                            self.view.backgroundColor = [UIColor redColor];
                    }
                    else
                    {
                        [self dismissViewControllerAnimated:YES completion:^{
                            NSLog(@"Hiding Loader with Error");
                        }];
                        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry Results are not yet available for this university seat number or it might not be a valid university seat number" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        [error show];
                    }
            });
        });

    }];
}


- (IBAction)checkButton:(id)sender
{
    [self start];
}
@end
