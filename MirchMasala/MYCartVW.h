//
//  MYCartVW.h
//  MirchMasala
//
//  Created by Mango SW on 15/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface MYCartVW : UIViewController<CCKFNavDrawerDelegate>
{
     NSInteger cellcount;
     float tempMainTotal;
    float tempTotal;
}
@property (weak, nonatomic) IBOutlet UITableView *MyTableVW;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end
