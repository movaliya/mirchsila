//
//  AboutUS.h
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface AboutUS : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (weak, nonatomic) IBOutlet UIWebView *WebViewAbout;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;


@end
