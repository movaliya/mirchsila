//
//  RestaurantMenuView.h
//  MirchMasala
//
//  Created by kaushik on 17/03/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface RestaurantMenuView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableDictionary *topCategoriesDic;

}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (weak, nonatomic) IBOutlet UITableView *MenuTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBR;
- (IBAction)Search_Click:(id)sender;
@end
