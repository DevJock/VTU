//
//  AppDelegate.h
//  VTU
//
//  Created by Chiraag Bangera on 7/30/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "ParsingLibs.h"
#import <iAd/iAd.h>

@interface AppDelegate : UIResponder
{
    NSMutableArray *details,*marks,*subjects;
    NSString *USN,*resultData,*status,*qUSN,*name,*sem,*verdict,*totalMarks;
    bool internetPresent ;
}


@property (strong , nonatomic)NSMutableArray *details,*marks,*subjects;
@property (strong,nonatomic)NSMutableDictionary *records;
@property (strong,nonatomic) NSString *USN,*resultData,*status,*qUSN,*name,*verdict,*sem,*totalMarks,*URL;
@property (nonatomic) bool internetPresent,done,captcha ;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADBannerView *UIiAD;
@end
