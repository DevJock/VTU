//
//  ParsingLibs.h
//  VTU
//
//  Consists of All Libs Required For Parsing and Data Mangaement
//
//  Created by Chiraag Bangera on 7/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface ParsingLibs : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSURLConnectionDownloadDelegate>

//OLD CODE
- (void)writeStringToFile:(NSString*)aString and:(NSString *)fileName;
- (NSString*)readStringFromFile:(NSString *)fileName;
-(NSArray *)listFileAtPath:(NSString *)path;
-(NSString *)sizeOfFolder;
- (void)deleteFile:(NSString *)fileName;


//UPDATED
-(BOOL)checkFileExists:(NSString *)filename;
-(NSMutableArray *)fileFormatter;
-(void) resultManager:(NSString *)USN and:(NSString *)sem;

-(int)numberOfSem:(NSMutableDictionary *)data;
-(NSArray *)constructRows:(NSMutableDictionary *)data;
-(NSString *)aggregateForUSN:(NSMutableDictionary *)data;

@end
