//
//  HomeView.m
//  MirchMasala
//
//  Created by Mango SW on 07/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "HomeView.h"
#import "CategoriesCell.h"
#import "MirchMasala.pch"
#import "AppDelegate.h"
#import "SubItemView.h"
#import "cartView.h"
#import "CVCell.h"
#import "GalleryVW.h"
#import "NewsVW.h"
#import "ReservationSubVW.h"
#import "RestaurantMenuView.h"
#import "MenuListWithImage.h"
#import "LocationView.h"
#import "cartView.h"


@interface HomeView ()
{
    UIImageView *Headerimg;
    NSMutableArray *OfferArr;
    NSMutableDictionary *Searchdic;
}
@property AppDelegate *appDelegate;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation HomeView
@synthesize CategoriesTableView,MenuView,HeaderScroll,PageControll;
@synthesize CartNotification_LBL,SearhBR;
@synthesize Pagecontrollypos,Pagecontrollhight;

- (BOOL)prefersStatusBarHidden
{
     return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
   
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        NSInteger qnttotal=0;
        for (int i=0; i<KmyappDelegate.MainCartArr.count; i++)
        {
            qnttotal=qnttotal+[[[KmyappDelegate.MainCartArr objectAtIndex:i]valueForKey:@"quatity"] integerValue];
        }
        
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
}

-(void)checkReservationState
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"reservationState" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //NSString *baseurl=@"https://tiffintom.com/api/private/request/data/";
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"reservationState"] objectForKey:@"SUCCESS"];
         
         if ([SUCCESS boolValue] ==YES)
         {
             NSString *checkRevState=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"reservationState"] objectForKey:@"result"] objectForKey:@"reservationState"];
             
             if ([checkRevState boolValue] ==YES)
             {
                 NSString *valueToSave = @"YES";
                 [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"reservationState"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else
             {
                 NSString *valueToSave = @"NO";
                 [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"reservationState"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             
             NSString *CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"NEWSNODATAHIDEOPTION"];
             
             [self CallNewsService];
             
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [KVNProgress dismissWithCompletion:^{
         }];
     }];
}

-(void)CallNewsService
{
    //[KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"news" forKey:@"METHOD"];
    
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
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"news"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NSArray *NewsDataArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"news"] objectForKey:@"result"] objectForKey:@"news"] mutableCopy];
             
             if (NewsDataArr.count==0)
             {
                 NSString *valueToSave = @"NO";
                 [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"NEWSNODATAHIDEOPTION"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else
             {
                 NSString *valueToSave = @"YES";
                 [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"NEWSNODATAHIDEOPTION"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
         }
         else
         {
             NSString *valueToSave = @"NO";
             [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"NEWSNODATAHIDEOPTION"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         [self callforsetmenubuttonstatus];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [KVNProgress dismissWithCompletion:^{
         }];
     }];
}

-(void)callforsetmenubuttonstatus
{
    CheckReservationState = [[NSUserDefaults standardUserDefaults] stringForKey:@"reservationState"];
    CheckOptionHidden = [[NSUserDefaults standardUserDefaults] stringForKey:@"NEWSNODATAHIDEOPTION"];
    
//    if (CheckReservationState==nil)
//    {
//        [KVNProgress show];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckHideNshow" object:self];
//    }
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSelector:@selector(BannerImageService) withObject:nil afterDelay:0.1];
        });
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        [KVNProgress dismissWithCompletion:^{
        }];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self checkReservationState];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        [KVNProgress dismissWithCompletion:^{
        }];
    }
    
    
    [self setupCollectionView];
    
    SearhBR.hidden=YES;
    SearhBR.layer.borderWidth = 1;
    SearhBR.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
   

    
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    CheckMenuBool=1;
    
    
    self.MenuView.layer.masksToBounds = NO;
    self.MenuView.layer.shadowOffset = CGSizeMake(0, 1);
    self.MenuView.layer.shadowOpacity = 0.5;
    
   // [self performSelector:@selector(dissmissActivityIndicator) withObject:nil afterDelay:5.0f];
}

-(void)setupCollectionView
{
    CheckReservationState = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"reservationState"];
    
    CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"NEWSNODATAHIDEOPTION"];
    
    if ([CheckReservationState isEqualToString:@"YES"])
    {
        if ([CheckOptionHidden isEqualToString:@"YES"])
        {
            ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"MenuBtn1",@"MenuBtn2",@"MenuBtn3",@"MenuBtn4",@"MenuBtn5",@"MenuBtn6", nil];
            TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location", nil];
        }
        else
        {
            ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"MenuBtn1",@"MenuBtn2",@"MenuBtn3",@"MenuBtn6", nil];
            TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Menu",@"Cart",@"Reservation",@"Location", nil];
        }
        
    }
    else
    {
        if ([CheckOptionHidden isEqualToString:@"YES"])
        {
            ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"MenuBtn1",@"MenuBtn2",@"MenuBtn4",@"MenuBtn5",@"MenuBtn6", nil];
            TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Menu",@"Cart",@"Gallery",@"News",@"Location", nil];
        }
        else
        {
            ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"MenuBtn1",@"MenuBtn2",@"MenuBtn6", nil];
            TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Menu",@"Cart",@"Location", nil];
        }
        
    }
    
    
    
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    [cell.AboutLable setHidden:YES];
    

}
-(void)dissmissActivityIndicator
{
    [KVNProgress dismiss] ;
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
    static NSString *cellIdentifier = @"cvCell";
    
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    
    
    [cell.titleLabel setText:[TitleNameSection objectAtIndex:indexPath.row]];
    
    
    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
   // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
   // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    NSString *imagename=[ImageNameSection objectAtIndex:indexPath.row];
    UIImage *imge=[UIImage imageNamed:imagename];
    [cell.IconImageview setImage:imge];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"reservationState"];
   CheckOptionHidden = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"NEWSNODATAHIDEOPTION"];
    if (CheckReservationState==nil)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckHideNshow" object:self];
    }
    
    if ([CheckReservationState isEqualToString:@"YES"])
    {
        if ([CheckOptionHidden isEqualToString:@"YES"])
        {
            if (indexPath.row==0)
            {
                //Gallery
                RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==1)
            {
                //Cart
                NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                
                NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                
                if (CoustmerID!=nil)
                {
                    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
                    [self.navigationController pushViewController:vcr animated:YES];
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
            else if (indexPath.row==2)
            {
                //reservation
                
                
                NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                
                NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                
                if (CoustmerID!=nil)
                {
                    ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
                    [self.navigationController pushViewController:vcr animated:YES];
                    
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
                //Gallery
                GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==4)
            {
                //news
                NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==5)
            {
                //Location
                LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }

        }
        else
        {
            if (indexPath.row==0)
            {
                //Gallery
                RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==1)
            {
                //Cart
                NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                
                NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                
                if (CoustmerID!=nil)
                {
                    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
                    [self.navigationController pushViewController:vcr animated:YES];
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
            else if (indexPath.row==2)
            {
                //reservation
                
                
                NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                
                NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                
                if (CoustmerID!=nil)
                {
                    ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
                    [self.navigationController pushViewController:vcr animated:YES];
                    
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
                //Location
                LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
        }
       
    }
    else
    {
        if ([CheckOptionHidden isEqualToString:@"YES"])
        {
            if (indexPath.row==0)
            {
                //Gallery
                RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==1)
            {
                //Cart
                NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                
                NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                
                if (CoustmerID!=nil)
                {
                    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
                    [self.navigationController pushViewController:vcr animated:YES];
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
            else if (indexPath.row==2)
            {
                //Gallery
                GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==3)
            {
                //news
                NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==4)
            {
                //Location
                LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
        }
        else
        {
            if (indexPath.row==0)
            {
                //Gallery
                RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
            else if (indexPath.row==1)
            {
                //Cart
                NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
                
                NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
                
                if (CoustmerID!=nil)
                {
                    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
                    [self.navigationController pushViewController:vcr animated:YES];
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
            else if (indexPath.row==2)
            {
                //Location
                LocationView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationView"];
                [self.navigationController pushViewController:vcr animated:YES];
            }
        }
        

    }
    
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(90, 120);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(105, 140);
    }
    else
    {
        mElementSize = CGSizeMake(120, 150);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return 12.0;
    }
    else if (IS_IPHONE_6)
    {
        return 10.0;
    }
    else if (IS_IPHONE_6P)
    {
        return 15.0;
    }
    return 15.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6P)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    
    return UIEdgeInsetsMake(10,15,10,15);  // top, left, bottom, right
}


-(void)SetheaderScroll
{
    NSArray* subviews = [[NSArray alloc] initWithArray: HeaderScroll.subviews];
    for (UIView* view in subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    int x=0;
    
    
    for (int i=0; i<OfferArr.count; i++)
    {
        Headerimg=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH, 260)];
        
        NSString *Urlstr=[[BannerImageARR valueForKey:@"image_path"] objectAtIndex:i];
        [Headerimg sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"HomeLogo"]];
        [Headerimg setShowActivityIndicatorView:YES];
        //Headerimg.image=[UIImage imageNamed:@"HomeLogo"];
        [HeaderScroll addSubview:Headerimg];
        
        if (OfferArr.count>i)
        {
            if (i==0)
            {
                for (int i =0 ; i<OfferArr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-190, SCREEN_WIDTH, 40)];
                        First_LBL.text=[OfferArr  valueForKey:@"A"];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-145, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[OfferArr valueForKey:@"B"];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-115, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[OfferArr valueForKey:@"C"];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:12];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:thert_LBL];
                    }
                }
            }
            else if (i==1)
            {
                for (int i =0 ; i<OfferArr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-190, SCREEN_WIDTH, 40)];
                        First_LBL.text=[OfferArr  valueForKey:@"A"];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-145, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[OfferArr valueForKey:@"B"];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-115, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[OfferArr valueForKey:@"C"];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:12];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:thert_LBL];
                    }
                }
            }
            else if (i==2)
            {
                for (int i =0 ; i<OfferArr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-190, SCREEN_WIDTH, 40)];
                        First_LBL.text=[OfferArr  valueForKey:@"A"];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-145, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[OfferArr valueForKey:@"B"];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-115, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[OfferArr valueForKey:@"C"];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:12];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:thert_LBL];
                    }
                }
            }
        }
        x=x+SCREEN_WIDTH;
    }
    _Back_IMG.hidden=YES;
    [HeaderScroll setContentSize:CGSizeMake(x, 130)];
    PageControll.numberOfPages =3;
    PageControll.currentPage = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    if (sender==HeaderScroll)
    {
        CGFloat pageWidth = HeaderScroll.frame.size.width;
        float fractionalPage = HeaderScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        PageControll.currentPage = page;
    }
}

-(void)CallforgetOffers
{
    if (OfferArr==nil)
    {
        [KVNProgress show] ;
        OfferArr=[[NSMutableArray alloc] init];
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        [dictSub setObject:@"offerText" forKey:@"METHOD"];
        
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
             // Dismiss
             [KVNProgress dismissWithCompletion:^{
                 // Things you want to do after the HUD is gone.
                 NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"offerText"] objectForKey:@"SUCCESS"];
                 if ([SUCCESS boolValue] ==YES)
                 {
                     OfferArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"offerText"] objectForKey:@"result"] objectForKey:@"offerText"] mutableCopy];
                     
                    
                     dispatch_async(dispatch_get_main_queue(), ^{
                          [self SetheaderScroll];
                     });
                 }
             }];
        }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Fail");
             // Dismiss
             [KVNProgress dismiss];
         }];
    }
    
}


#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (CheckMenuBool==1)
    {
         return topCategoriesDic.count;
    }
    else
    {
         return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoriesCell";
    CategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    if (CheckMenuBool==1)
    {
        cell.TitleLable.text=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        cell.TitleLable.hidden=YES;
        cell.ArrowImageVW.hidden=YES;
        cell.AboutLable.attributedText=AboutMessage;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CheckMenuBool==1)
    {
        SubItemView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubItemView"];
        vcr.CategoryId=[[topCategoriesDic valueForKey:@"id"] objectAtIndex:indexPath.section];
        vcr.categoryName=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:vcr animated:YES];
        
        Pagecontrollypos.constant=160;
        Pagecontrollhight.constant=37;
        HeaderScroll.hidden=NO;
        SearhBR.hidden=YES;
        [SearhBR resignFirstResponder];
        topCategoriesDic=[Searchdic mutableCopy];
        [CategoriesTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CheckMenuBool!=1)
    {
        return 400;
    }
    return 44;
    
}
-(void)BannerImageService
{
    if (BannerImageARR==nil)
    {
       // [KVNProgress show] ;
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        [dictSub setObject:@"bannerImages" forKey:@"METHOD"];
        
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
             [KVNProgress dismissWithCompletion:^{
                 // Things you want to do after the HUD is gone.
                 NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"bannerImages"] objectForKey:@"SUCCESS"];
                 if ([SUCCESS boolValue] ==YES)
                 {
                     BannerImageARR=[[NSMutableArray alloc]init];
                     BannerImageARR=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"bannerImages"] objectForKey:@"result"] objectForKey:@"bannerImages"] mutableCopy];
                     [self performSelector:@selector(CallforgetOffers) withObject:nil afterDelay:0.0f];
                 }
             }];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Fail");
             [KVNProgress dismissWithCompletion:^{
             }];
         }];
    }
    else
    {
        [KVNProgress dismissWithCompletion:^{
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MenuBtn_action:(id)sender
{
    // Set Bool and hide lable
    CheckMenuBool=1;
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    [cell.AboutLable setHidden:YES];
    [cell.TitleLable setHidden:NO];
    [cell.ArrowImageVW setHidden:NO];
    [CategoriesTableView reloadData];

    
   //Disable
    self.AboutLine.backgroundColor=[UIColor whiteColor];
    [self.AboutMenuBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
    self.menuLine.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.MenuBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
    
}

- (IBAction)AboutBtn_action:(id)sender
{
    // Set Bool hide & show lable and image
    CheckMenuBool=0;
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    [cell.AboutLable setHidden:NO];
    [cell.TitleLable setHidden:YES];
    [cell.ArrowImageVW setHidden:YES];
     [CategoriesTableView reloadData];
    
    //Disable
    self.menuLine.backgroundColor=[UIColor whiteColor];
    [self.MenuBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
    self.AboutLine.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.AboutMenuBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];

}

- (IBAction)TopBarCartBtn_action:(id)sender
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    if (CoustmerID!=nil)
    {
        cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
        [self.navigationController pushViewController:vcr animated:YES];;
        
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==51)
    {
        if (buttonIndex == 1)
        {
            LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
            [self.navigationController  pushViewController:vcr animated:YES];
        }
    }
}


- (IBAction)NavtoggleBtn_action:(id)sender
{
    [self.rootNav drawerToggle];

}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

#pragma mark - SerachBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    Pagecontrollypos.constant=160;
    Pagecontrollhight.constant=37;
    HeaderScroll.hidden=NO;
    SearhBR.hidden=YES;

    topCategoriesDic=[Searchdic mutableCopy];
    [SearhBR resignFirstResponder];
    [CategoriesTableView reloadData];
    
    [statusBarView removeFromSuperview];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    Pagecontrollypos.constant=0;
    Pagecontrollhight.constant=0;
    HeaderScroll.hidden=YES;
    
    SearhBR.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [CategoriesTableView reloadData];
    [statusBarView removeFromSuperview];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     topCategoriesDic=[Searchdic mutableCopy];
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        topCategoriesDic=[Searchdic mutableCopy];
        [CategoriesTableView reloadData];
        return;
    }
    
   NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in topCategoriesDic)
    {
        NSString *wineName = [wine objectForKey:@"categoryName"];
        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    topCategoriesDic=[resultObjectsArray mutableCopy];
    [CategoriesTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    topCategoriesDic=[Searchdic mutableCopy];
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
    {
        topCategoriesDic=[Searchdic mutableCopy];
        [CategoriesTableView reloadData];
        return;
    }
   NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in topCategoriesDic)
    {
        NSString *wineName = [wine objectForKey:@"categoryName"];
        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    topCategoriesDic=[resultObjectsArray mutableCopy];
    [CategoriesTableView reloadData];
    [SearhBR resignFirstResponder];
}

- (IBAction)Search_Click:(id)sender
{
    
    SearhBR.hidden=NO;
    SearhBR.text=@"";
    [SearhBR becomeFirstResponder];
    
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
   statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.view addSubview:statusBarView];
}
@end
