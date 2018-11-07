//
//  SettingsViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 7/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize usnTextField,spaceLabel;

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
    [usnTextField resignFirstResponder];
    appDelegate.qUSN = usnTextField.text;
    [p writeStringToFile:appDelegate.qUSN and:@"USN_Data.dat"];
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ChiraagBangera.WidgetShares"];
    [sharedDefaults setObject:usnTextField.text forKey:@"USN"];
     [sharedDefaults synchronize];
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
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [usnTextField setDelegate:self];
    p = [[ParsingLibs alloc] init];
    if([p checkFileExists:@"USN_Data.dat"])
        appDelegate.qUSN = [p readStringFromFile:@"USN_Data.dat"];
    usnTextField.text = appDelegate.qUSN;
    spaceLabel.text = [p sizeOfFolder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [usnTextField resignFirstResponder];
    appDelegate.qUSN = usnTextField.text;
    [p writeStringToFile:appDelegate.qUSN and:@"USN_Data.dat"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    appDelegate.qUSN = textField.text;
    [p writeStringToFile:appDelegate.qUSN and:@"USN_Data.dat"];
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength > 10)
    {
        [textField resignFirstResponder];
    }
    return (newLength > 10) ? NO : YES;
}

- (IBAction)clearData:(id)sender
{
    NSString *extension = @"plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        if ([[filename pathExtension] isEqualToString:extension])
        {
            NSLog(@"%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    spaceLabel.text = [p sizeOfFolder];
}
- (IBAction)setupPush:(id)sender
{
    [self performSegueWithIdentifier:@"setup" sender:nil];
}
@end
