//
//  JJHViewController.m
//  JJHRequest
//
//  Created by Anima18 on 09/11/2017.
//  Copyright (c) 2017 Anima18. All rights reserved.
//

#import "JJHViewController.h"
#import <JJHRequest/JJHRequest.h>
#import "DataObject.h"
#import "User.h"

@interface JJHViewController ()

@end

@implementation JJHViewController

const NSString *BASE_PATH = @"http://192.168.60.176:8080/webService/";

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0) {
        documentDirectory = [paths objectAtIndex:0];
    }
    NSLog(@"%@", documentDirectory);
    
    [self loadFrameworkNamed:@"MyFramework"];
}


- (IBAction)postRequest:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@userInfo/getAllUserInfoLayer.action", BASE_PATH];
    [[[[[[[JJHNetworkRequest request] url:url] method:POST]
        dataClass:@"DataObject"]
       addParam:@"name" value:@"Chris"]
      addParam:@"password" value:@"123456"]
     data:^(id result) {
         DataObject *data = result;
         User *user = data.data.rows[0];
         NSLog(@"%@", user.name);
     } failure:^(NSUInteger code, NSString *errorMessage) {
         NSLog(@"%zi , %@", code, errorMessage);
         
     }];
}

- (void)loadFrameworkNamed:(NSString *)bundleName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0) {
        documentDirectory = [paths objectAtIndex:0];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *bundlePath = [documentDirectory stringByAppendingPathComponent:[bundleName stringByAppendingString:@".framework"]];
    
    // Check if new bundle exists
    if (![manager fileExistsAtPath:bundlePath]) {
        NSLog(@"No framework update");
        bundlePath = [[NSBundle mainBundle]
                      pathForResource:bundleName ofType:@"framework"];
        
        // Check if default bundle exists
        if (![manager fileExistsAtPath:bundlePath]) {
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Framework not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alertView show];
            NSLog(@"Framework not found");
        }
    }
    
    // Load bundle
    NSError *error = nil;
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlePath];
    if (frameworkBundle && [frameworkBundle loadAndReturnError:&error]) {
        NSLog(@"Load framework successfully");
    }else {
        NSLog(@"Failed to load framework with err: %@",error);
    }
}
@end
