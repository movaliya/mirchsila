//
//  MessageVW.h
//  MirchMasala
//
//  Created by jignesh solanki on 01/02/2018.
//  Copyright © 2018 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface MessageVW : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UITableView *TableVW;
@end
