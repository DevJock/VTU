//
//  ParsingLibs.m
//  VTU
//
//  Created by Chiraag Bangera on 7/31/14.
//  Copyright (c) 2014 Chiraag Bangera. All rights reserved.
//

#import "ParsingLibs.h"
#import "WebViewController.h"

@implementation ParsingLibs
{
    NSArray *Rawsubjects,*Rawmarks,*Rawdetails,*Rawname,*Rawdata,*Rawtotal;
    NSString *cData;
    WebViewController *wvc;
}


NSMutableArray *inM,*exM,*tM;

-(NSMutableArray *)listFileAtPath:(NSString *)path
{
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    return [directoryContent mutableCopy];
}

-(NSString *)sizeOfFolder
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsPath] error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    NSString *file;
    unsigned long long int folderSize = 0;
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[[self documentsPath] stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}


- (void)writeStringToFile:(NSString*)aString and:(NSString *)fileName
{
    NSLog(@"Writing Data to File <%@>",fileName);
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

-(NSString *)readStringFromFile:(NSString *)fileName
{
    NSLog(@"Reading Data from File <%@>",fileName);
    return  [NSString stringWithContentsOfFile:[self pathToFile:fileName] encoding:NSUTF8StringEncoding error:nil];
}


- (void)deleteFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
    if (error)
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    else
    {
        NSLog(@"Deleteted: %@",fileName);
    }
}



// UPDATED CODE

-(NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(NSString *)pathToFile:(NSString *)fileName
{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    return fileAtPath;
    
}

-(BOOL)checkFileExists:(NSString *)filename
{
    NSString* foofile = [[self documentsPath] stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] fileExistsAtPath:foofile];
}


-(NSData *)fetchDatafromServer:(NSString *)URLString
{
    NSURL *url = [[NSURL alloc]initWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSData *GETReply      = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return GETReply;
}

-(NSDictionary *) parseJSONResponse:(NSData *)URLResponse
{
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:URLResponse
                                                                        options:kNilOptions
                                                                          error:nil];
    return jsonResponse;
}


-(NSString *)organizeData:(NSMutableDictionary *)data
{
    NSString *sem = @"";
    int largest = 0;
    for (int i =0;i<[data count]; i++)
    {
        if([data objectForKey:[NSString stringWithFormat:@"%d",i+1]] != nil)
            largest = i+1;
    }
    sem = [NSString stringWithFormat:@"%d",largest];
    return sem;
}

-(BOOL)dataAcquirable:(NSMutableDictionary *)data and:(NSString *)sem
{
    if([[data objectForKey:@"semesters"] objectForKey:sem] == nil)
        return false;
    else
        return true;
}

-(void)handleData:(NSMutableDictionary *)data and:(NSString *)sem
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.name = @"";
    appDelegate.totalMarks = @"";
    appDelegate.verdict = @"";
    appDelegate.sem = @"";
    appDelegate.subjects = [[NSMutableArray alloc] init];
    appDelegate.marks = [[NSMutableArray alloc] init];
    appDelegate.details = [[NSMutableArray alloc] init];
    
    if([sem isEqual:@"0"])
    {
        appDelegate.sem = [self organizeData:data];
    }
    else
    {
        appDelegate.sem = sem;
    }
    NSMutableDictionary *semDetails = [[data objectForKey:@"semesters"] objectForKey:appDelegate.sem];

    //General
    appDelegate.name = [NSString stringWithFormat:@"%@\n%@",[data objectForKey:@"name"],[data objectForKey:@"usn"]];
    appDelegate.totalMarks =[ NSString stringWithFormat:@"%@ - [%@]",[semDetails objectForKey:@"total"],[semDetails objectForKey:@"score"]];
    appDelegate.verdict = [semDetails objectForKey:@"grade"];
    NSArray *subs = [semDetails objectForKey:@"subjects"];
    for(int i=0;i<[subs count];i++)
    {
        //Subjects
        NSString *subName = [NSString stringWithFormat:@"%@ - [%@]",[[subs objectAtIndex:i] objectForKey:@"name"],[[subs objectAtIndex:i] objectForKey:@"code"]];
        [appDelegate.subjects addObject:subName];
        //Marks
        [appDelegate.marks addObject:[[subs objectAtIndex:i] objectForKey:@"external_marks"]];
        [appDelegate.marks addObject:[[subs objectAtIndex:i] objectForKey:@"internal_marks"]];
        [appDelegate.marks addObject:[[subs objectAtIndex:i] objectForKey:@"total_marks"]];
        //Status
        [appDelegate.details addObject:[[subs objectAtIndex:i] objectForKey:@"status"]];
    }
}

-(NSMutableDictionary *)fetchResultsFromServer:(NSString *)USN and:(NSString *)sem
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *tdict = [[NSMutableDictionary alloc] init];
    NSString *URL = @"";
    if([sem isEqualToString:@"0"])
    {
        NSLog(@"Checking for Latest Result");
        URL = [NSString stringWithFormat:@"%@/overall_status_of/%@",appDelegate.URL,[USN lowercaseString]];
        NSLog(@"Using URL: %@",URL);
        data = [[self parseJSONResponse:[self fetchDatafromServer:URL]] mutableCopy];
        NSString *lsem = ([self organizeData:data]);
        NSLog(@"Fetching Latest Results for %@ sem",lsem);
        [data setValue:lsem forKey:@"latest_sem"];
        [data setValue:USN forKey:@"usn"];
        URL = [NSString stringWithFormat:@"%@/marks_of/%@/%@",appDelegate.URL,[USN lowercaseString],lsem];
        if([data objectForKey:@"semesters"] != nil)
            tdict = [data objectForKey:@"semesters"];
        [tdict setObject:[self parseJSONResponse:[self fetchDatafromServer:URL]] forKey:lsem];
        [data setObject:tdict forKey:@"semesters"];
    }
    else
    {
        NSLog(@"Checking for %@ Sem result",sem);
        data = [[self fileManager:USN with:nil and:@"READ"] mutableCopy];
        if([data objectForKey:sem] == nil )
        {
            NSLog(@"Results not Available for that Sem");
            return nil;
        }
        else
        {
            URL = [NSString stringWithFormat:@"%@/marks_of/%@/%@",appDelegate.URL,[USN lowercaseString],sem];
            if([data objectForKey:@"semesters"] != nil)
                tdict = [data objectForKey:@"semesters"];
            [tdict setObject:[self parseJSONResponse:[self fetchDatafromServer:URL]] forKey:sem];
            [data setObject:tdict forKey:@"semesters"];
            [data setValue:USN forKey:@"usn"];
        }
    }
    return data;
}



-(void) resultManager:(NSString *)USN and:(NSString *)sem
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *temp2 = [[NSMutableDictionary alloc] init];
    bool used_local;
    bool fileExists = [self checkFileExists:[NSString stringWithFormat:@"%@.plist",USN]];
    if(fileExists)
    {
        if([sem isEqualToString:@"0"])
        {
            NSLog(@"Found Local Records. Locating Latest Results.");
            temp = [[self fileManager:USN with:nil and:@"READ"] mutableCopy];
            NSString *lsem = [self organizeData:temp];
            temp2 = [[self fetchResultsFromServer:USN and:[NSString stringWithFormat:@"%d",[lsem intValue] + 1]] mutableCopy] ;
            if([[temp2 objectForKey:@"error"] intValue] != 0 || temp2 == nil)
            {
                NSLog(@"No New Results Found. Using Local Data");
                sem = [temp objectForKey:@"latest_sem"];
                used_local = true;
            }
            else
            {
                NSLog(@"Downloaded Latest Results");
                used_local = false;
                [temp setValue:temp2 forKey:lsem];
                sem = lsem;
            }
        }
        else
        {
            NSLog(@"Found Local Records. Locating %@ Sem Results.",sem);
            temp = [self fileManager:USN with:nil and:@"READ"];
            bool acq = [self dataAcquirable:temp and:sem];
            if(acq)
            {
                NSLog(@"Located results for %@ sem",sem);
                used_local = true;
            }
            else
            {
                NSLog(@"Cannot Find Results Offline. Will Try Online");
                used_local = false;
                temp = [self fetchResultsFromServer:USN and:sem];
            }
        }
    }
    else
    {
        NSLog(@"No Local Data Found. Retreiving Online Results");
        temp = [self fetchResultsFromServer:USN and:sem];
        used_local = false;
    }
    if(temp != nil)
    {
        if(!used_local)
        {
            [self fileManager:USN with:temp and:@"WRITE"];
        }
        [self handleData:temp and:sem];
        appDelegate.resultData = @"DATA";
    }
    else
    {
       appDelegate.resultData = @"NO_DATA";
    }
}




-(NSMutableDictionary *)fileManager:(NSString *)USN with:(NSDictionary *)Data and:(NSString *)command
{
    NSString *fileName  = [NSString stringWithFormat:@"%@.plist",USN];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    if([command isEqualToString:@"READ"])
    {
        temp = [self getDataFromFile:fileName];
        return temp;
    }
    else if([command isEqualToString:@"WRITE"])
    {
        if([self checkFileExists:fileName])
        {
            NSLog(@"Saving Results for %@",USN);
            [self saveResultToRecords:Data and:fileName];
        }
        else
        {
            NSLog(@"Creating Records for %@",USN);
            [self saveResultToRecords:Data and:fileName];
        }
        return nil;
    }
    else
        return nil;
}




-(void)saveResultToRecords:(NSDictionary *)theData and:(NSString *)fileName
{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [theData writeToFile:fileAtPath atomically:YES];
}

-(NSMutableDictionary *)getDataFromFile:(NSString *)fileName
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [[NSDictionary dictionaryWithContentsOfFile:[self pathToFile:fileName]] mutableCopy];
    return dict;
}


-(NSString *)getDetailsFromFile:(NSString *)USN
{
    NSMutableDictionary *temp = [self fileManager:USN with:nil and:@"READ"];
    NSString *data;
    data =  [NSString stringWithFormat:@"%@ %@",[temp objectForKey:@"name"],[temp objectForKey:@"usn"]];
    return data;
}


// ARCHIVE VIEW CONTROLLER

-(NSString *)aggregateForUSN:(NSMutableDictionary *)data
{
    NSString *string = @"";
    double aggregate = 0.0;
    int count = 0;
    for (int i =0;i<[data count]; i++)
    {
        if([data objectForKey:[NSString stringWithFormat:@"%d",i+1]] != nil)
        {
            aggregate += [[[data objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"score"] doubleValue];
            count ++;
        }
        string = [NSString stringWithFormat:@"%.2lf",aggregate / count];
    }
    return string;
}


-(NSArray *)constructRows:(NSMutableDictionary *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i =0;i<[data count]; i++)
    {
        if([data objectForKey:[NSString stringWithFormat:@"%d",i+1]] != nil)
        {
            [array addObject:[data objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
        }
    }

    return [array mutableCopy];
}

-(int)numberOfSem:(NSMutableDictionary *)data
{
    int n = 0;
    n = [[self organizeData:data] intValue];
    return n;
}


-(NSMutableArray *)fileFormatter
{
    NSMutableArray *fileList = [[NSMutableArray alloc] init];
    NSMutableArray *files = [[NSMutableArray alloc] init];
    fileList = [[self listFileAtPath:[self documentsPath]] mutableCopy];
    for(int i=0;i< [fileList count]; i++)
    {
        NSString *usn = [fileList objectAtIndex:i];
        NSString *dat = [usn componentsSeparatedByString:@"."][0];
        if([dat isEqualToString:@"USN_Data"])
        {
            [fileList removeObjectAtIndex:i];
        }
    }
    for(int i=0;i< [fileList count];i++)
    {
         [files addObject:[self detailsForFile:[fileList objectAtIndex:i ]]];
    }
    return files;
}

-(NSMutableDictionary *)detailsForFile:(NSString *)fileName
{
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    fileName = [fileName componentsSeparatedByString:@"."][0];
    temp = [self fileManager:fileName with:nil and:@"READ"];
    return temp;
}

@end
