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
#import "ReservationVW.h"
#import "RestaurantMenuView.h"


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

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Menu",@"Cart",@"Reservation",@"Gallery",@"News",@"Location", nil];
    
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    
    
    SearhBR.hidden=YES;
    SearhBR.layer.borderWidth = 1;
    SearhBR.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

    
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    
    CheckMenuBool=1;
    
    [cell.AboutLable setHidden:YES];
    
    
    self.MenuView.layer.masksToBounds = NO;
    self.MenuView.layer.shadowOffset = CGSizeMake(0, 1);
    self.MenuView.layer.shadowOpacity = 0.5;
    
   
    
    
    // Call Category List
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self performSelector:@selector(CategoriesList) withObject:nil afterDelay:0.0f];
        [self performSelector:@selector(CallforgetOffers) withObject:nil afterDelay:0.0f];
       
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
   // [self SetheaderScroll];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
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
    
    if (indexPath.row==0)
    {
        //Gallery
        RestaurantMenuView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantMenuView"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    
   else if (indexPath.row==2)
    {
        //Gallery
        ReservationVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationVW"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==3)
    {
        //Gallery
        GalleryVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryVW"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else if (indexPath.row==4)
    {
        //Gallery
        NewsVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsVW"];
        [self.navigationController pushViewController:vcr animated:YES];
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
    
    
    for (int i=0; i<3; i++)
    {
        Headerimg=[[UIImageView alloc]initWithFrame:CGRectMake(x, -20, SCREEN_WIDTH, 260)];
        Headerimg.image=[UIImage imageNamed:@"HomeLogo"];
        [HeaderScroll addSubview:Headerimg];
        
        if (OfferArr.count>i)
        {
            if (i==0)
            {
                NSString *MainStr=[OfferArr valueForKey:@"A"];
                NSArray *arr = [MainStr componentsSeparatedByString:@"#"];
                for (int i =0 ; i<arr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-150, SCREEN_WIDTH, 40)];
                        First_LBL.text=[arr objectAtIndex:0];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-110, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[arr objectAtIndex:1];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-80, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[arr objectAtIndex:2];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:10];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:thert_LBL];
                    }
                }
            }
            else if (i==1)
            {
                NSString *MainStr=[OfferArr valueForKey:@"B"];
                NSArray *arr = [MainStr componentsSeparatedByString:@"#"];
                for (int i =0 ; i<arr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-150, SCREEN_WIDTH, 40)];
                        First_LBL.text=[arr objectAtIndex:0];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-110, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[arr objectAtIndex:1];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-80, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[arr objectAtIndex:2];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:10];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:thert_LBL];
                    }
                }

            }
            else if (i==2)
            {
                NSString *MainStr=[OfferArr valueForKey:@"B"];
                NSArray *arr = [MainStr componentsSeparatedByString:@"#"];
                for (int i =0 ; i<arr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-150, SCREEN_WIDTH, 40)];
                        First_LBL.text=[arr objectAtIndex:0];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-110, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[arr objectAtIndex:1];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-80, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[arr objectAtIndex:2];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:10];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [HeaderScroll addSubview:thert_LBL];
                    }
                }

            }
        }
        x=x+SCREEN_WIDTH;
    }
    
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
         [KVNProgress dismiss];
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"offerText"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             OfferArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"offerText"] objectForKey:@"result"] objectForKey:@"offerText"] mutableCopy];
             
             [self SetheaderScroll];
         }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

-(void)CategoriesList
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
         [KVNProgress dismiss];
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             topCategoriesDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"];
             
             Searchdic =[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"] mutableCopy];
             if (topCategoriesDic) {
                 [CategoriesTableView reloadData];
             }
         }
         
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
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
