//
//  HomeView.h
//  MirchMasala
//
//  Created by Mango SW on 07/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"
@interface HomeView : UIViewController<CCKFNavDrawerDelegate ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableDictionary *topCategoriesDic;
    BOOL CheckMenuBool;
    NSAttributedString *AboutMessage;
    UIView *statusBarView;
    
    NSMutableArray *ImageNameSection;
    NSMutableArray *TitleNameSection;
   
}
@property (strong, nonatomic) IBOutlet UIImageView *Back_IMG;
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet UITableView *CategoriesTableView;
@property (weak, nonatomic) IBOutlet UIView *MenuView;
@property (weak, nonatomic) IBOutlet UIButton *MenuBtn;
@property (weak, nonatomic) IBOutlet UILabel *menuLine;
@property (weak, nonatomic) IBOutlet UIButton *AboutMenuBtn;
@property (weak, nonatomic) IBOutlet UILabel *AboutLine;

@property (strong, nonatomic) IBOutlet UIScrollView *HeaderScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *PageControll;
@property (strong, nonatomic) IBOutlet UISearchBar *SearhBR;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Pagecontrollypos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Pagecontrollhight;
- (IBAction)Search_Click:(id)sender;
@end
