//
//  OrderDetailView.h
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface OrderDetailView : UIViewController
{
    NSString *StatusMsg;
    NSMutableDictionary *childerDic;
}
@property (strong, nonatomic) NSMutableDictionary *OrderHistryDetailDic;

@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (strong, nonatomic) NSString *StatusMsg;
@property (weak, nonatomic) IBOutlet UITableView *OrderDetailTableView;

@end
