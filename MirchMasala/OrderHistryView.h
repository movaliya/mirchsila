//
//  OrderHistryView.h
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"


@interface OrderHistryView : UIViewController<CCKFNavDrawerDelegate>
{
    NSString *OrderStatus;
}
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UITableView *OrderHistyTableView;
@property (weak, nonatomic) IBOutlet UIButton *CompleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *pendingBtn;
@property (weak, nonatomic) IBOutlet UIButton *CancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *LBL_complete;
@property (weak, nonatomic) IBOutlet UILabel *LBL_pending;
@property (weak, nonatomic) IBOutlet UILabel *LBL_cancel;
@property (weak, nonatomic) IBOutlet UIView *MenuView;

@end
