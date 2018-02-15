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
#import "ReservationSubVW.h"
#import "GalleryVW.h"
#import "NewsVW.h"
#import "SocialView.h"
#import "MYCartVW.h"
#import "LocationView.h"
#import "VideoGallaryView.h"
#import "SubItemView.h"
#import "MessageVW.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:)  name:@"CallForShowMenu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationCheck:)  name:@"CheckHideNshow" object:nil];
    
    self.appDelegate = [AppDelegate sharedInstance];
    self.drawerView.Collectionview.hidden=YES;
    
    NSString *CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"reservationState"];
    NSString *CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"NEWSNODATAHIDEOPTION"];
    if (CheckReservationState==nil)
    {
        CheckReservationState=@"NO";
        CheckOptionHidden=@"NO";
    }
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Location",@"Information",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"LocationIcon",@"AboutusIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
           
        }
        else
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Gallery",@"News",@"Location",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Location",@"Information",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"LocationIcon",@"AboutusIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            
        }
        
    }
    else
    {
        //MessageIcon
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Location",@"Profile",@"Order History",@"Information",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
           
        }
        else
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Location",@"Profile",@"Order History",@"Information",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            
        }
        
    }
    
    
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
    
   
  
    
    
    [self.drawerView.Collectionview registerClass:[SideMenuCollectioVW class] forCellWithReuseIdentifier:@"SideMenuCollectioVW"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120, 120)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.drawerView.Collectionview setCollectionViewLayout:flowLayout];
}


-(void)CategoriesList
{
    self.drawerView.drawerTableView.hidden=NO;
    self.drawerView.Collectionview.hidden=YES;
    
    if (topCategoriesDic==nil)
    {
        [KVNProgress show] ;
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        [dictSub setObject:@"topCategories" forKey:@"METHOD"];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
        NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
        
        [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
        [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
        
        
        NSError* error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.requestSerializer = serializer;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         {
             //NSLog(@"responseObject==%@",responseObject);
             //[KVNProgress dismiss];
             [KVNProgress dismissWithCompletion:^{
                 
                 // Things you want to do after the HUD is gone.
                 NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"SUCCESS"];
                 if ([SUCCESS boolValue] ==YES)
                 {
                     topCategoriesDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"];
                     [self.drawerView.drawerTableView reloadData];
                 }
             }];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Fail");
             //[KVNProgress dismiss] ;
             [KVNProgress dismissWithCompletion:^{
                 
                 // Things you want to do after the HUD is gone.
             }];
         }];
    }
}

-(void)CheckLoginArr
{
    //self.drawerView.drawerTableView.hidden=YES;
    //self.drawerView.Collectionview.hidden=NO;
    
    self.appDelegate = [AppDelegate sharedInstance];
    
    NSString *CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"reservationState"];
    NSString *CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"NEWSNODATAHIDEOPTION"];
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Location",@"Information",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"LocationIcon",@"AboutusIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            
        }
        else
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Gallery",@"News",@"Location",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Location",@"Information",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"LocationIcon",@"AboutusIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            
        }
        
    }
    else
    {
        
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Location",@"Profile",@"Order History",@"Information",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            
        }
        else
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Location",@"Profile",@"Order History",@"Information",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            
        }
        
    }
    [self.drawerView.Collectionview reloadData];
    
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
    
    
    self.appDelegate = [AppDelegate sharedInstance];
    
    NSString *CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"reservationState"];
    NSString *CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"NEWSNODATAHIDEOPTION"];
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
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
                else if (indexPath.row==3)
                {
                    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                    
                    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                    
                    if (CoustmerID!=nil)
                    {
                        ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
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
                    GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==5)
                {
                    NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==6)
                {
                    LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==7)
                {
                    AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==8)
                {
                    SocialView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SocialView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==9)
                {
                    VideoGallaryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoGallaryView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==10)
                {
                    ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==11)
                {
                    if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
            }
            else
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
                else if (indexPath.row==3)
                {
                    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                    
                    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                    
                    if (CoustmerID!=nil)
                    {
                        ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
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
                    LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                    [super pushViewController:vcr animated:YES];
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
                    if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
            }
        }
        else
        {
             if ([CheckOptionHidden isEqualToString:@"YES"])
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
                 else if (indexPath.row==3)
                 {
                     GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==4)
                 {
                     NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==5)
                 {
                     LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==6)
                 {
                     AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==7)
                 {
                     SocialView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SocialView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==8)
                 {
                     VideoGallaryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoGallaryView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==9)
                 {
                     ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==10)
                 {
                     if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
             }
            else
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
                else if (indexPath.row==3)
                {
                    LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==4)
                {
                    AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==5)
                {
                    ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==6)
                {
                    if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
            }
        }
        
    }
    else
    {
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
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
                
                else if (indexPath.row==3)
                {
                    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                    
                    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                    
                    if (CoustmerID!=nil)
                    {
                        ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
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
                    GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==5)
                {
                    NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==6)
                {
                    LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                    [super pushViewController:vcr animated:YES];
                }
                
                else if (indexPath.row==7)
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
                else if (indexPath.row==8)
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
                else if (indexPath.row==9)
                {
                    AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==10)
                {
                    SocialView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SocialView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==11)
                {
                    VideoGallaryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoGallaryView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==12)
                {
                    ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                    [super pushViewController:vcr animated:YES];
                }
                
                else if (indexPath.row==13)
                {
                    MessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageVW"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==14)
                {
                    if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
            }
            else
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
                
                else if (indexPath.row==3)
                {
                    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                    
                    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                    
                    if (CoustmerID!=nil)
                    {
                        ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
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
                    LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                    [super pushViewController:vcr animated:YES];
                }
                
                else if (indexPath.row==5)
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
                else if (indexPath.row==6)
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
                else if (indexPath.row==7)
                {
                    AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==8)
                {
                    ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                    [super pushViewController:vcr animated:YES];
                }
                
                else if (indexPath.row==9)
                {
                    MessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageVW"];
                    [super pushViewController:vcr animated:YES];
                }
                
                else if (indexPath.row==10)
                {
                    if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
            }
        }
        else
        {
             if ([CheckOptionHidden isEqualToString:@"YES"])
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
                 else if (indexPath.row==3)
                 {
                     GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==4)
                 {
                     NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==5)
                 {
                     LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==6)
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
                 else if (indexPath.row==7)
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
                 else if (indexPath.row==8)
                 {
                     AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==9)
                 {
                     SocialView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SocialView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==10)
                 {
                     VideoGallaryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoGallaryView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==11)
                 {
                     ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==12)
                 {
                     MessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageVW"];
                     [super pushViewController:vcr animated:YES];
                 }
                 else if (indexPath.row==13)
                 {
                     if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
             }
            else
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
                else if (indexPath.row==3)
                {
                    LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==4)
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
                else if (indexPath.row==5)
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
                else if (indexPath.row==6)
                {
                    AboutUS *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==7)
                {
                    ContactUsView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUsView"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==8)
                {
                    MessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageVW"];
                    [super pushViewController:vcr animated:YES];
                }
                else if (indexPath.row==9)
                {
                    if ([[TitleNameSection objectAtIndex:indexPath.row] isEqualToString:@"Login or Signup"])
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
            }
            
        }
        
        
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
        mElementSize = CGSizeMake(119, 119.5);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topCategoriesDic.count+1;
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
    if (indexPath.row==0)
    {
        cell.Title_LBL.text=@"Menu";
    }
    else
    {
        cell.Title_LBL.text=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.row-1];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.drawerView.drawerTableView.hidden=YES;
    self.drawerView.Collectionview.hidden=NO;
    if (indexPath.row==0)
    {
        HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
        [super pushViewController:vcr animated:YES];
    }
    else
    {
        SubItemView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubItemView"];
        vcr.CategoryId=[[topCategoriesDic valueForKey:@"id"] objectAtIndex:indexPath.row-1];
        vcr.categoryName=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.row-1];
        [super pushViewController:vcr animated:YES];
    }
   
    [self closeNavigationDrawer];
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


- (void) receiveTestNotification:(NSNotification *) notification
{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [self CategoriesList];
        
    });
}
- (void) receiveNotificationCheck:(NSNotification *) notification
{
    NSString *CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"reservationState"];
    NSString *CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"NEWSNODATAHIDEOPTION"];
    if (CheckReservationState==nil)
    {
        CheckReservationState=@"NO";
        CheckOptionHidden=@"NO";
    }
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Location",@"Information",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"LocationIcon",@"AboutusIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            
        }
        else
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Gallery",@"News",@"Location",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Location",@"Information",@"Contact Us",@"Login or Signup", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"LocationIcon",@"AboutusIcon",@"contactUsIcon-1",@"sidemenuLogin", nil];
            }
            
        }
        
    }
    else
    {
        //MessageIcon
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Reservation",@"Location",@"Profile",@"Order History",@"Information",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"ReservationIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            
        }
        else
        {
            if ([CheckOptionHidden isEqualToString:@"YES"])
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Gallery",@"News",@"Location",@"Profile",@"Order History",@"Information",@"Social",@"Video Gallery",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"GalleryIcon",@"NewsIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"socailIcon",@"videoGalleryIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            else
            {
                TitleNameSection=[[NSMutableArray alloc]initWithObjects: @"Home",@"Menu",@"Cart",@"Location",@"Profile",@"Order History",@"Information",@"Contact Us",@"Message",@"Logout", nil];
                ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"HomeIcon",@"RestaurantIcon",@"CartIcon",@"LocationIcon",@"UserSideIcon",@"OrderHistryIcon",@"AboutusIcon",@"contactUsIcon-1",@"MessageIcon",@"sidemenuLogin", nil];
            }
            
        }
        
    }
 [self.drawerView.Collectionview reloadData];
}

@end
