//
//  OrderSummay_Detail.h
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSummay_Detail : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ProductName_LBL;
@property (weak, nonatomic) IBOutlet UILabel *With_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Without_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Quatity_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ProductPrice_LBL;
@property (weak, nonatomic) IBOutlet UILabel *With_title;
@property (weak, nonatomic) IBOutlet UILabel *without_title;

@end
