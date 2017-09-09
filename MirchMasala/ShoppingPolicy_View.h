//
//  ShoppingPolicy_View.h
//  MirchMasala
//
//  Created by Mango SW on 17/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface ShoppingPolicy_View : UIViewController<CCKFNavDrawerDelegate>

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UILabel *NotificationCartLBL;
@property (weak, nonatomic) IBOutlet UIWebView *MyWebView;

@end
