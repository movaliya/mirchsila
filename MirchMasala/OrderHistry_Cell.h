//
//  OrderHistry_Cell.h
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistry_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OderNumber_LBL;
@property (weak, nonatomic) IBOutlet UILabel *OrderStatus_LBL;
@property (weak, nonatomic) IBOutlet UILabel *OrderAmount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *OderDate_LBL;
@property (weak, nonatomic) IBOutlet UIButton *CancelBtn;
@property (strong, nonatomic) IBOutlet UIImageView *CancleIMG;
@property (weak, nonatomic) IBOutlet UILabel *Comment_LBL;

@end
