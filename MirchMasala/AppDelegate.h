//
//  AppDelegate.h
//  MirchMasala
//
//  Created by Mango SW on 04/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *MainCartArr;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *MainCartArr;

+ (AppDelegate *)sharedInstance;

+(BOOL)IsValidEmail:(NSString *)checkString;

+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate;
+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate;
+(BOOL)connectedToNetwork;
-(void)GetPublishableKey;
- (BOOL)isUserLoggedIn;

@end

