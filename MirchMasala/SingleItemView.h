//
//  SignleItemView.h
//  MirchMasala
//
//  Created by kaushik on 10/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleItemView : UIViewController
{
    NSMutableArray *ItemArr;
    NSUInteger chechPlusMinus;
    NSString *CategoryId;
    BOOL autobool;

}
@property (strong, nonatomic) NSMutableArray *ItemArr;
@property (strong, nonatomic) NSString *CategoryId;


- (IBAction)Back_Click:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *BackView;
- (IBAction)ItemCart_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *OptionBTN;
- (IBAction)Option_Click:(id)sender;
- (IBAction)Minush_Click:(id)sender;
- (IBAction)PlushBTN_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Qnt_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Price_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;


@property (strong, nonatomic) IBOutlet UIView *OptionView;
- (IBAction)Cancle:(id)sender;
- (IBAction)Confirm_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *WithTBL;
@property (strong, nonatomic) IBOutlet UITableView *WithoutTBL;
@property (strong, nonatomic) IBOutlet UIView *OptionTitleView;

@property (strong, nonatomic) IBOutlet UILabel *CartNotification_LBL;
- (IBAction)TopCartBTN_Click:(id)sender;
@end
