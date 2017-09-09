//
//  cartView.h
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface cartView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableDictionary *subCategoryDic;
    NSMutableArray *arrayInt;
    NSMutableDictionary *AllProductIngredientsDIC;
    NSMutableDictionary *ProductIngredDic;
    NSMutableArray *WithIntegrate,*withoutIntegrate;
    NSInteger subItemIndex;
    
    
    NSInteger cellcount;
    NSInteger ButtonTag;
    NSUInteger chechPlusMinus;
    float GandTotal;
    NSInteger ExtraCellINT;
    
}
@property (weak, nonatomic) IBOutlet UILabel *cartNotification_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Notavailable_LBL;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UITableView *cartTable;
@property (strong, nonatomic) IBOutlet UILabel *CheckoutTotal_LBL;


@property (strong, nonatomic) IBOutlet UIView *OptionView;

- (IBAction)Confirm_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *WithTBL;
@property (strong, nonatomic) IBOutlet UITableView *WithoutTBL;
@property (strong, nonatomic) IBOutlet UIView *OptionTitleView;
@end
