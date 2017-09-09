//
//  CartTableCell.h
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@property (strong, nonatomic) IBOutlet UIButton *Change_BTN;
@property (strong, nonatomic) IBOutlet UILabel *Price_LBL;
@property (strong, nonatomic) IBOutlet UITextField *Qnt_TXT;
@property (strong, nonatomic) IBOutlet UIButton *Update_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Close_BTN;
@property (strong, nonatomic) IBOutlet UILabel *WithOption_LBL;
@property (strong, nonatomic) IBOutlet UILabel *WithoutOptiion_LBL;
@property (strong, nonatomic) IBOutlet UILabel *With_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Without_LBL;


@end
