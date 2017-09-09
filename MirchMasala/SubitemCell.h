//
//  SubitemCell.h
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubitemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UILabel *ProductName;
@property (weak, nonatomic) IBOutlet UILabel *PriceLable;
@property (weak, nonatomic) IBOutlet UIButton *MinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *PlusBtn;
@property (weak, nonatomic) IBOutlet UILabel *Quatity_LBL;
@property (strong, nonatomic) IBOutlet UIButton *Cart_BTN;

@end
