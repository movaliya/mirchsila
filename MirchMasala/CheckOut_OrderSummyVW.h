//
//  CheckOut_OrderSummyVW.h
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"
@interface CheckOut_OrderSummyVW : UIViewController
{
    NSInteger cellcount;
}
@property (strong, nonatomic) NSMutableDictionary *MINDelveryCollectioDic1;

@property (strong, nonatomic) NSString *Comment2View;
@property (strong, nonatomic) NSString *deliveryCharge1;
@property (weak, nonatomic) IBOutlet UITableView *TableVW;
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@end
