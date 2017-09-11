//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "MenuCell.h"
#import "HomeView.h"
#import "AppDelegate.h"
#import "MirchMasala.pch"
#import "cartView.h"
#import "LoginVW.h"
#import "OrderHistryView.h"
#import "ContactUsView.h"
#import "AboutUS.h"
#import "ProfileView.h"
#import "RestaurantMenuView.h"
#import "ShoppingPolicy_View.h"
#import "SideMenuCollectioVW.h"
#import "ReservationVW.h"
#import "GalleryVW.h"
#import "NewsVW.h"

#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350

@interface CCKFNavDrawer ()
{
    NSMutableArray *TitleArr,*ImgArr;
}
@property AppDelegate *appDelegate;

@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;

@end

@implementation CCKFNavDrawer

#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [AppDelegate sharedInstance];
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        TitleArr=[[NSMutableArray alloc] initWithObjects:@"Home",@"Restaurant Menu",@"Profile",@"My Cart",@"Order History",@"About Us",@"Contact Us",@"Shopping Policy",@"Login & Signup", nil];
    }
    else
    {
       TitleArr=[[NSMutableArray alloc] initWithObjects:@"Home",@"Restaurant Menu",@"Profile",@"My Cart",@"Order History",@"About Us",@"Contact Us",@"Shopping Policy",@"Sign Out", nil];
    }
    
    
    ImgArr=[[NSMutableArray alloc] initWithObjects:@"HomeIcon",@"RestaurantIcon",@"UserIcon",@"CartIcon",@"OrderHistryIcon",@"AboutusIcon",@"ContactUsIcon",@"ShoppingPolicyIcon",@"LogoutLoginIcon", nil];
    
    
    [self setUpDrawer];
    
    if (SCREEN_HEIGHT==480)
    {
        self.drawerView.LogoWidht.constant=170;
        self.drawerView.LogoHight.constant=86;
        self.drawerView.LBLLeading.constant=25;
        self.drawerView.LBL_Trailing.constant=25;
        self.drawerView.LogoLBLGap.constant=20;
    }
    else
    {
        self.drawerView.LogoWidht.constant=212;
        self.drawerView.LogoHight.constant=114;
        self.drawerView.LBLLeading.constant=20;
        self.drawerView.LBL_Trailing.constant=20;
        self.drawerView.LogoLBLGap.constant=29;
    }
    
   
   
    TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"About Us",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
     ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
    
    [self.drawerView.Collectionview registerClass:[SideMenuCollectioVW class] forCellWithReuseIdentifier:@"SideMenuCollectioVW"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120, 120)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.drawerView.Collectionview setCollectionViewLayout:flowLayout];


}

-(void)CheckLoginArr
{
    self.appDelegate = [AppDelegate sharedInstance];
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
         TitleArr=[[NSMutableArray alloc] initWithObjects:@"Home",@"Restaurant Menu",@"Profile",@"My Cart",@"Order History",@"About Us",@"Contact Us",@"Shopping Policy",@"Login & Signup", nil];
    }
    else
    {
        TitleArr=[[NSMutableArray alloc] initWithObjects:@"Home",@"Restaurant Menu",@"Profile",@"My Cart",@"Order History",@"About Us",@"Contact Us",@"Shopping Policy",@"Sign Out", nil];
    }
    
    
    ImgArr=[[NSMutableArray alloc] initWithObjects:@"HomeIcon",@"RestaurantIcon",@"UserIcon",@"CartIcon",@"OrderHistryIcon",@"AboutusIcon",@"ContactUsIcon",@"ShoppingPolicyIcon",@"LogoutLoginIcon", nil];
    
    [self.drawerView.drawerTableView reloadData];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return TitleNameSection.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"SideMenuCollectioVW";
    
    SideMenuCollectioVW *cell = (SideMenuCollectioVW *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    
    
    [cell.ItemTitel_LBL setText:[TitleNameSection objectAtIndex:indexPath.row]];
    
    
    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    NSString *imagename=[ImageNameSection objectAtIndex:indexPath.row];
    UIImage *imge=[UIImage imageNamed:imagename];
    [cell.ItemIMG setImage:imge];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0)
    {
        HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==1)
    {
        RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
        [super pushViewController:vcr animated:YES];
    }
    
    else if (indexPath.row==3)
    {
        ReservationVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationVW"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==4)
    {
        GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==5)
    {
        NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==9)
    {
        AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==12)
    {
        ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
        [super pushViewController:vcr animated:YES];
    }
    
    
    
    [self closeNavigationDrawer];
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(118.5, 118.5);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(140, 140);
    }
    else
    {
        mElementSize = CGSizeMake(154.2, 154.2);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1.5,0,1.5,0);   // top, left, bottom, right
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self BackClick:self];
}

#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.pan_gr setEnabled:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.pan_gr setEnabled:YES];
    }
    return vc;
}

#pragma mark - drawer

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    // load drawer view
    self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
    
    self.meunHeight = self.view.frame.size.height;
    self.menuWidth = self.view.frame.size.width;
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];
    
    // drawer list
//    [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)]; // statuesBarHeight+navBarHeight
//    self.drawerView.drawerTableView.dataSource = self;
//    self.drawerView.drawerTableView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    MenuCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    self.drawerView.drawerTableView.rowHeight = cell.frame.size.height;
    [self.drawerView.drawerTableView registerNib:nib forCellReuseIdentifier:@"MenuCell"];
    
    self.drawerView.drawerTableView.dataSource = self;
    self.drawerView.drawerTableView.delegate = self;
    
    
    [self.drawerView.Back_BTN addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // gesture on self.view
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.pan_gr.maximumNumberOfTouches = 1;
    self.pan_gr.minimumNumberOfTouches = 1;
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
}

-(void)BackClick:(id)sender
{
    [self closeNavigationDrawer];
}

- (void)drawerToggle
{
    if (!self.isOpen) {
        [self openNavigationDrawer];
    }else{
        [self closeNavigationDrawer];
    }
}

#pragma open and close action

- (void)openNavigationDrawer
{
//    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
}

- (void)closeNavigationDrawer
{
//    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer
{
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
//    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan)
    {
//        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"changing");
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
//        NSLog(@"end");
        if (self.drawerView.center.x>0){
            [self openNavigationDrawer];
        }else if (self.drawerView.center.x<0){
            [self closeNavigationDrawer];
        }
    }

}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIGHT==480)
    {
        return 44;
    }
    else
    {
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return TitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
   
    if (indexPath.row==8)
    {
        cell.IconWidth.constant=14;
        cell.IconHeight.constant=17;
        cell.IconX.constant=15;
        cell.ImgLblGap.constant=16;
        
    } /*
    if (indexPath.row==1)
    {
        cell.IconWidth.constant=20;
        cell.IconHeight.constant=15;
        cell.IconX.constant=8;
        cell.ImgLblGap.constant=15.5;
        
    }
    if (indexPath.row==2)
    {
        cell.IconWidth.constant=14;
        cell.IconHeight.constant=14;
        cell.IconX.constant=8;
        cell.ImgLblGap.constant=19;
    }
    if (indexPath.row==3)
    {
        cell.IconWidth.constant=17;
        cell.IconHeight.constant=17;
        cell.IconX.constant=8;
        cell.ImgLblGap.constant=16;
    }
    if (indexPath.row==4)
    {
        cell.IconWidth.constant=14;
        cell.IconHeight.constant=13;
        cell.IconX.constant=8;
        cell.ImgLblGap.constant=19;
    }
    if (indexPath.row==5)
    {
        cell.IconWidth.constant=15;
        cell.IconHeight.constant=15;
        cell.IconX.constant=8;
        cell.ImgLblGap.constant=18;
    }
    if (indexPath.row==6)
    {
        cell.IconWidth.constant=14;
        cell.IconHeight.constant=20;
        cell.IconX.constant=8;
        cell.ImgLblGap.constant=18;
        
    }*/
    cell.Title_LBL.text=[TitleArr objectAtIndex:indexPath.row];
    cell.IconIMG.image=[UIImage imageNamed:[ImgArr objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==1)
    {
        RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==2)
    {
        NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
        
        NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        if (CoustmerID!=nil)
        {
            ProfileView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileView"];
            [super pushViewController:vcr animated:YES];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please First Login"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Login",nil];
            alert.tag=51;
            [alert show];
        }
       
    }
    else if (indexPath.row==3)
    {
        NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
        
        NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        if (CoustmerID!=nil)
        {
            cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
            [super pushViewController:vcr animated:YES];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please First Login"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Login",nil];
            alert.tag=51;
            [alert show];
        }
    }
    else if (indexPath.row==4)
    {
        NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
        
        NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        if (CoustmerID!=nil)
        {
            OrderHistryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderHistryView"];
            [super pushViewController:vcr animated:YES];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please First Login"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Login",nil];
            alert.tag=52;
            [alert show];
        }
       
    }
    else if (indexPath.row==5)
    {
        AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==6)
    {
        ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==7)
    {
         // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m-masala.co.uk/shoppingpolicy"]];
        ShoppingPolicy_View *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingPolicy_View"];
        [super pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==8)
    {
        if ([[TitleArr objectAtIndex:indexPath.row] isEqualToString:@"Login & Signup"])
        {
            [self checkLoginAndPresentContainer];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Are you sure want to Logout?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Logout",nil];
            alert.tag=50;
            [alert show];
        }
        
    }
    [self closeNavigationDrawer];
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    //[cell.Title_LBL setTextColor:[UIColor redColor]];
    return indexPath;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // the user clicked Logout
    if (alertView.tag==50)
    {
        if (buttonIndex == 1)
        {
             [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LoginUserDic"];
           // [[FBSession activeSession] closeAndClearTokenInformation];
            
            [self CheckLoginArr];
            [super popToRootViewControllerAnimated:NO];
            
            //[self checkLoginAndPresentContainer];
        }
    }
    if (alertView.tag==51)
    {
        if (buttonIndex == 1)
        {
             [self checkLoginAndPresentContainer];
        }
    }
    if (alertView.tag==52)
    {
        if (buttonIndex == 1)
        {
            [self checkLoginAndPresentContainer];
        }
    }
}

-(void)checkLoginAndPresentContainer
{
    LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
    [super  pushViewController:vcr animated:YES];
}

@end
