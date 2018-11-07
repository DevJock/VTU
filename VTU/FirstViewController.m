//
//  FirstViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 7/30/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "FirstViewController.h"
#import "ResultViewController.h"
#import "LoaderViewController.h"
#import "ParsingLibs.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize usnTextField,fetchButton;
@synthesize connection,connectionText,activityInd,moreb;
 
bool internetActive = false, hostActive = false;

bool usnEntered = false;

bool moreEnabled = true ;


- (AppDelegate *) appdelegate
{
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






- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [usnTextField setDelegate:self];
    p = [ParsingLibs alloc];
    [moreb setEnabled:moreEnabled];
    if([usnTextField.text length] >= 10)
    { 
        usnEntered = true;
        [fetchButton setEnabled:YES];
    }
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [usnTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
     if(newLength ==11)
    {
        [textField resignFirstResponder];
    }
    if(newLength >= 10)
    {
        fetchButton.enabled = true;
    }
    else
    {
        fetchButton.enabled = false;
    }
    return (newLength > 10) ? NO : YES;
}


-(void)start
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoaderViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"loaderView"];
    [add setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:add animated:YES completion:^{
    }];
}




- (IBAction)fetchButton:(id)sender
{
   NSString *sem = @"0";
   [usnTextField resignFirstResponder];
    [fetchButton setEnabled:NO];
    [moreb setEnabled:NO];
    [self performSelectorInBackground:@selector(start) withObject:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
    [p resultManager:[usnTextField text] and:sem];
         dispatch_sync(dispatch_get_main_queue(), ^{
                if([appDelegate.resultData isEqualToString:@"DATA"])
                    {
                            [self dismissViewControllerAnimated:YES completion:^{
                            NSLog(@"Hiding Loader and Loading View");
                            [self performSegueWithIdentifier:@"fr1" sender:self];
                            }];
                    }
                else if([appDelegate.resultData isEqualToString:@"NO_DATA"])
                    {
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry Results are not yet available for this university seat number or it might not be a valid university seat number" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                            [error show];
                            }];
                    }
                else if([appDelegate.resultData isEqualToString:@"CLOUDFLARE"])
                    {
                        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Sorry, But your'e IP address has been blacklisted by the website's adminstrator." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        [error show];
                    }
         });
    });
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [fetchButton setEnabled:YES];
    [moreb setEnabled:moreEnabled];
}




- (IBAction)moreButton:(id)sender
{
    [usnTextField resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Advance Options" message:@"Enter Semester" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Fetch Results", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput ;
    [[alertView textFieldAtIndex:0] setText:usnTextField.text];
    [alertView textFieldAtIndex:0].autocapitalizationType =UITextAutocapitalizationTypeAllCharacters;
    [[alertView textFieldAtIndex:1] setSecureTextEntry:NO];
    [[alertView textFieldAtIndex:0] setPlaceholder:@"Enter USN"];
    [[alertView textFieldAtIndex:1] setPlaceholder:@"Enter Semester Number"];
    [[alertView textFieldAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
    [[alertView textFieldAtIndex:1] setTextAlignment:NSTextAlignmentCenter];
    [[alertView textFieldAtIndex:1] setText:@""];
    [alertView show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *sem = [[alertView textFieldAtIndex:1] text];
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        [[alertView textFieldAtIndex:1] resignFirstResponder];
        [p resultManager:[[alertView textFieldAtIndex:0] text] and:sem];
        if([appDelegate.resultData isEqualToString:@"DATA"])
        [self performSegueWithIdentifier:@"fr1" sender:self];
        else
        {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry Results are not yet available for this university seat number or it might not be a valid university seat number" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [error show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"fr1"])
    {
        ResultViewController  *nextVC = (ResultViewController *)[segue destinationViewController];
        nextVC.name = @"";
        [nextVC.subject removeAllObjects];
        [nextVC.marks removeAllObjects];
        [nextVC.details removeAllObjects];
        nextVC.name =  [NSString stringWithString:appDelegate.name];
        nextVC.sem = [NSString stringWithString:appDelegate.sem];
        nextVC.verdict = [NSString stringWithString:appDelegate.verdict];
        nextVC.total = [NSString stringWithString:appDelegate.totalMarks];
        nextVC.subject = [[NSMutableArray alloc] initWithArray:[appDelegate subjects]];
        nextVC.marks = [[NSMutableArray alloc] initWithArray:[appDelegate marks]];
        nextVC.details = [[NSMutableArray alloc] initWithArray:[appDelegate details]];
    }
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


@end
