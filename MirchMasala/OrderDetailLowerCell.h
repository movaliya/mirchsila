//
//  OrderDetailLowerCell.h
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailLowerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ProductName_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ProductPrice_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ProductQuatity_LBL;
@property (weak, nonatomic) IBOutlet UILabel *withIntegrate_LBL;
@property (weak, nonatomic) IBOutlet UILabel *WithoutIntegrate_LBL;
@property (weak, nonatomic) IBOutlet UILabel *without_title;
@property (weak, nonatomic) IBOutlet UILabel *With_Title;

@end
