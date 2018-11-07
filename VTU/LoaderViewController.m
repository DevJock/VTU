//
//  LoaderViewController.m
//  VTU
//
//  Created by Chiraag Bangera on 8/9/15.
//  Copyright (c) 2015 Chiraag Bangera. All rights reserved.
//

#import "LoaderViewController.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController

@synthesize image;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    self.view.opaque = false;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self performSelectorInBackground:@selector(runSpinAnimationOnView) withObject:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runSpinAnimationOnView) object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) runSpinAnimationOnView
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.7* 0.8];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 50000;
    [image.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


@end
