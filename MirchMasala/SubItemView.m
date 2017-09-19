//
//  SubItemView.m
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SubItemView.h"
#import "SubitemCell.h"
#import "MirchMasala.pch"
#import "AppDelegate.h"
#import "LoginVW.h"
#import "cartView.h"
#import "SubitemCellWithIMG.h"
#import "SingleItemView.h"

@interface SubItemView ()
{
    NSMutableArray *WithSelectArr,*WithoutSelectArr;
    NSMutableArray *withSelectMain,*withoutselectMain;
    NSMutableArray *PraseArr;
    NSMutableDictionary *Searchdic;
    BOOL ImageFag;
}

@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;
@end

@implementation SubItemView
@synthesize ItemTableView;
@synthesize CategoryId,categoryName,CategoryTitleLBL;
@synthesize dic,MainCount;
@synthesize OptionView,WithTBL,WithoutTBL,CartNotification_LBL;
@synthesize HeaderViewHight,HraderTitleY,SearchBR,ItemCollectionView;

- (BOOL)prefersStatusBarHidden
{
     return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
    
    
    
    //ItemCollectionView.hidden=YES;
    ItemTableView.hidden=YES;
    
    SearchBR.hidden=YES;
    SearchBR.layer.borderWidth = 0.1;
    SearchBR.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(198/255.0) blue:(143/255.0) alpha:1.0].CGColor;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil )
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
    
    OptionView.hidden=YES;
    //Register Table Cell
    UINib *nib = [UINib nibWithNibName:@"SubitemCell" bundle:nil];
    SubitemCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    ItemTableView.rowHeight = cell.frame.size.height;
    
    [ItemTableView registerNib:nib forCellReuseIdentifier:@"SubitemCell"];
    CategoryTitleLBL.text=categoryName;
    
    
   
    
    //Register Collectionview Cell
    [ItemCollectionView registerClass:[SubitemCellWithIMG class] forCellWithReuseIdentifier:@"SubitemCellWithIMG"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [ItemCollectionView setCollectionViewLayout:flowLayout];
    
    self.OptionTitleView.layer.masksToBounds = NO;
    self.OptionTitleView.layer.shadowOffset = CGSizeMake(0, 1);
    // self.MenuView.layer.shadowRadius = 5;
    self.OptionTitleView.layer.shadowOpacity = 0.5;
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
         [self SUBCategoriesList];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   
}


-(void)SUBCategoriesList
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:CategoryId forKey:@"CATEGORYID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"products" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&error];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             subCategoryDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"products"];
             PraseArr=[subCategoryDic mutableCopy];
             
             Searchdic= subCategoryDic;
             
             AllProductIngredientsDIC=[subCategoryDic valueForKey:@"ingredients"];
             arrayInt = [[NSMutableArray alloc] init];
             for (int i = 0; i <subCategoryDic.count; i++)
             {
                 [arrayInt addObject:@"1"];
             }
             
             dic=[[NSMutableDictionary alloc]init];
             MainCount=[[NSMutableDictionary alloc]init];
             [dic setObject:arrayInt forKey:@"Count"];
             [MainCount setObject:arrayInt forKey:@"MainCount"];
            
             
             ImageFag=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"containImg"] boolValue];
             //ImageFag=YES;
             
             if (ImageFag==YES)
             {
                 ItemCollectionView.hidden=NO;
                 [ItemCollectionView reloadData];
             }
             else
             {
                 ItemCollectionView.hidden=YES;
                 ItemTableView.hidden=NO;
                 [ItemTableView reloadData];
             }
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}


#pragma mark Collection view layout things
#pragma mark COLLECTION VIEW

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return subCategoryDic.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup cell identifier
    static NSString *cellIdentifier = @"SubitemCellWithIMG";
    
    SubitemCellWithIMG *cell = (SubitemCellWithIMG *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    
    // cell.Title_Hight.constant=0;
    cell.ItemTitel_LBL.text=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:indexPath.row];
    
    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    NSString *imagename=@"slider_image_1.png";
    UIImage *imge=[UIImage imageNamed:imagename];
    cell.ItemIMG.image=imge;
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingleItemView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleItemView"];
    vcr.ItemArr=[PraseArr objectAtIndex: indexPath.row];
    vcr.CategoryId=CategoryId;
    [self.navigationController  pushViewController:vcr animated:YES];
    
    
    
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(139, 139);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(166, 166);
    }
    else
    {
        mElementSize = CGSizeMake(185, 185);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
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
    
    return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
}



#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 1;
    }
    return subCategoryDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==WithTBL )
    {
        return WithIntegrate.count;
    }
    else if (tableView==WithoutTBL )
    {
        return withoutIntegrate.count;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 1;
    }
    return 13.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return nil;
    }
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIButton *ChkButton=[[UIButton alloc]initWithFrame:CGRectMake(8, 14.5, 15, 15)];
        UILabel *titleLBL=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 44)];
        UILabel *PriceLBL=[[UILabel alloc]initWithFrame:CGRectMake(WithTBL.frame.size.width-50, 0, 40, 44)];
        
        if (IS_IPHONE_4 || isIPhone5)
        {
            titleLBL.font=[UIFont systemFontOfSize:11.5f];
            PriceLBL.font=[UIFont systemFontOfSize:11.5f];
        }
        else
        {
            titleLBL.font=[UIFont systemFontOfSize:13.0f];
            PriceLBL.font=[UIFont systemFontOfSize:13.0f];
        }
        
        PriceLBL.textAlignment=NSTextAlignmentRight;
        
        if (tableView==WithTBL)
        {
            if ([[WithSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_chkIcon"] forState:UIControlStateNormal];
            }
            else
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_UnchkIcon"] forState:UIControlStateNormal];
            }
             [ChkButton addTarget:self action:@selector(WithChkbox_click:) forControlEvents:UIControlEventTouchUpInside];
            titleLBL.text=[[WithIntegrate valueForKey:@"ingredient_name"] objectAtIndex:indexPath.row];
            PriceLBL.text=[NSString stringWithFormat:@"£%@",[[WithIntegrate valueForKey:@"price"] objectAtIndex:indexPath.row]];


        }
        else
        {
            PriceLBL=[[UILabel alloc]initWithFrame:CGRectMake(WithoutTBL.frame.size.width-50, 0, 40, 44)];
            PriceLBL.textAlignment=NSTextAlignmentRight;
            
            if (IS_IPHONE_4 || isIPhone5)
            {
                titleLBL.font=[UIFont systemFontOfSize:11.5f];
                PriceLBL.font=[UIFont systemFontOfSize:11.5f];
            }
            else
            {
                titleLBL.font=[UIFont systemFontOfSize:13.0f];
                PriceLBL.font=[UIFont systemFontOfSize:13.0f];
            }
            
            if ([[WithoutSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_chkIcon"] forState:UIControlStateNormal];
            }
            else
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_UnchkIcon"] forState:UIControlStateNormal];
            }
            [ChkButton addTarget:self action:@selector(WithoutChkbox_click:) forControlEvents:UIControlEventTouchUpInside];
            titleLBL.text=[[withoutIntegrate valueForKey:@"ingredient_name"] objectAtIndex:indexPath.row];
            PriceLBL.text=[NSString stringWithFormat:@"£%@",[[WithIntegrate valueForKey:@"price_without"] objectAtIndex:indexPath.row]];
        }
        
        ChkButton.tag=indexPath.row;
        [cell addSubview:ChkButton];
        [cell addSubview:titleLBL];
        [cell addSubview:PriceLBL];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
    
    static NSString *CellIdentifier = @"SubitemCell";
    SubitemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    cell.PlusBtn.tag=indexPath.section;
    cell.MinusBtn.tag=indexPath.section;
    cell.optionBtn.tag=indexPath.section;
    cell.Cart_BTN.tag=indexPath.section;

    
    [cell.PlusBtn addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.MinusBtn addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionBtn addTarget:self action:@selector(OptionClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Cart_BTN addTarget:self action:@selector(Cart_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSInteger *Main=[[[MainCount valueForKey:@"MainCount"] objectAtIndex:indexPath.section] integerValue];
    
    NSInteger *Second=[[[dic valueForKey:@"Count"] objectAtIndex:indexPath.section] integerValue];
    
    if (Main==Second)
    {
        cell.Quatity_LBL.text=[NSString stringWithFormat:@"%ld",Main];
    }
    else
    {
        cell.Quatity_LBL.text=[NSString stringWithFormat:@"%ld",Second];
    }
    
    cell.ProductName.text=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:indexPath.section];
    cell.PriceLable.text=[NSString stringWithFormat:@"£%@",[[subCategoryDic valueForKey:@"price"] objectAtIndex:indexPath.section]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithoutTBL)
    {
        if ([[WithoutSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
        {
            [WithoutSelectArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];
            NSInteger indx=[withoutselectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [withoutselectMain removeObjectAtIndex:indx];
        }
        else
        {
            [WithoutSelectArr replaceObjectAtIndex:indexPath.row withObject:@"YES"];
            [withoutselectMain addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

        }
        
        [WithoutTBL reloadData];
    }
    else if (tableView==WithTBL)
    {
        if ([[WithSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
        {
            [WithSelectArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];
            NSInteger indx=[withSelectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [withSelectMain removeObjectAtIndex:indx];
        }
        else
        {
            [WithSelectArr replaceObjectAtIndex:indexPath.row withObject:@"YES"];
             [withSelectMain addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        
        [WithTBL reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 44;
    }
    return 65;
    
}

-(void)Cart_Click:(id)sender
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    UIButton *senderButton = (UIButton *)sender;
    
    if ([KmyappDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
        OptionView.hidden=YES;
        [WithTBL reloadData];
        [WithoutTBL reloadData];
        
        NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:senderButton.tag];
        NSString *Productid=[[subCategoryDic valueForKey:@"id"] objectAtIndex:senderButton.tag];
        
        NSArray *CategoryIdArr=[KmyappDelegate.MainCartArr valueForKey:@"CategoryId"];
        NSLog(@"=== %@",KmyappDelegate.MainCartArr);
        if ([CategoryIdArr containsObject:CategoryId])
        {
            NSArray *ProductidArr=[KmyappDelegate.MainCartArr valueForKey:@"Productid"];
            if ([ProductidArr containsObject:Productid])
            {
                for (int i=0; i<ProductidArr.count; i++)
                {
                    if ([[[KmyappDelegate.MainCartArr valueForKey:@"Productid"] objectAtIndex:i] isEqualToString:Productid])
                    {
                        NSArray *ingredientArr=[[KmyappDelegate.MainCartArr valueForKey:@"ingredient"] objectAtIndex:i];
                        if (![ingredientArr isKindOfClass:[NSArray class]])
                        {
                            NSString *addqnt=[NSString stringWithFormat:@"%d",[Quatity integerValue]+[[[KmyappDelegate.MainCartArr valueForKey:@"quatity"] objectAtIndex:i] integerValue]];
                            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                            NSDictionary *oldDict = (NSDictionary *)[KmyappDelegate.MainCartArr objectAtIndex:i];
                            [newDict addEntriesFromDictionary:oldDict];
                            [newDict setObject:addqnt forKey:@"quatity"];
                            [KmyappDelegate.MainCartArr replaceObjectAtIndex:i withObject:newDict];
                            [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
                            KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
                            [AppDelegate showErrorMessageWithTitle:@"" message:@"Product Added in Cart." delegate:nil];
                            
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
                            break;
                        }
                        else
                        {
                            if (i==ProductidArr.count-1)
                            {
                                [self Addnewitemincart:senderButton.tag];
                                break;
                            }
                            
                        }
                    }
                }
            }
            else
            {
                [self Addnewitemincart:senderButton.tag];
            }
        }
        else
        {
            [self Addnewitemincart:senderButton.tag];
        }
    }
}

-(void)Addnewitemincart :(NSInteger)btntag
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    NSString *prductNM=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:btntag];
    NSString *prductPRICE=[[subCategoryDic valueForKey:@"price"] objectAtIndex:btntag];
    NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:btntag];
    NSString *Productid=[[subCategoryDic valueForKey:@"id"] objectAtIndex:btntag];
    
    NSMutableDictionary *AddTocardDic = [[NSMutableDictionary alloc] init];
    [AddTocardDic setObject:prductNM forKey:@"productName"];
    [AddTocardDic setObject:prductPRICE forKey:@"price"];
    [AddTocardDic setObject:Quatity forKey:@"quatity"];
    [AddTocardDic setObject:Productid forKey:@"Productid"];
    [AddTocardDic setObject:CategoryId forKey:@"CategoryId"];
    
    [AddTocardDic setObject:@"" forKey:@"ingredient"];
    NSLog(@"AddTocardDic===%@",AddTocardDic);
    
    
    
    KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    [KmyappDelegate.MainCartArr addObject:AddTocardDic];
    [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
    NSLog(@"==%@",KmyappDelegate.MainCartArr);
    [AppDelegate showErrorMessageWithTitle:@"" message:@"Product Added in Cart." delegate:nil];
    
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

-(void)WithoutChkbox_click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld",(long)senderButton.tag);
    
    if ([[WithoutSelectArr objectAtIndex:senderButton.tag] isEqualToString:@"YES"])
    {
        [WithoutSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"NO"];
        NSInteger indx=[withoutselectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
        [withoutselectMain removeObjectAtIndex:indx];
        
    }
    else
    {
        [WithoutSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"YES"];
        [withoutselectMain addObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
    }
    
    [WithoutTBL reloadData];
}

-(void)WithChkbox_click:(id)sender
{
     UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld",(long)senderButton.tag);
    
    if ([[WithSelectArr objectAtIndex:senderButton.tag] isEqualToString:@"YES"])
    {
        [WithSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"NO"];
        NSInteger indx=[withSelectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
        [withSelectMain removeObjectAtIndex:indx];
    }
    else
    {
        [WithSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"YES"];
        [withSelectMain addObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];

    }
    [WithTBL reloadData];
}

-(void)PlushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    SubitemCell *cell = (SubitemCell *)[ItemTableView cellForRowAtIndexPath:pathOfTheCell];
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    
    NSInteger count = [cell.Quatity_LBL.text integerValue];
    count = count + 1;
    cell.Quatity_LBL.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    [arrayInt replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
    [dic setObject:arrayInt forKey:@"Count"];
    
    
    ButtonTag=senderButton.tag;
    chechPlusMinus=1;
    //[TableView reloadData];
}

-(void)MinushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    SubitemCell *cell = (SubitemCell *)[ItemTableView cellForRowAtIndexPath:pathOfTheCell];
    
    NSInteger count = [cell.Quatity_LBL.text integerValue];
    count = count - 1;
    if (count!=0)
    {
        cell.Quatity_LBL.text = [NSString stringWithFormat:@"%ld",(long)count];
        [arrayInt replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
        [dic setObject:arrayInt forKey:@"Count"];
        ButtonTag=senderButton.tag;
        chechPlusMinus=0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)OptionClick:(id)sender
{
    OptionView.hidden=NO;
    UIButton *senderButton = (UIButton *)sender;
    subItemIndex=senderButton.tag;
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    ProductIngredDic=[[subCategoryDic valueForKey:@"ingredients"] objectAtIndex:senderButton.tag];
    
    int count=0;
    withoutIntegrate=[[NSMutableArray alloc] init];
    WithIntegrate=[[NSMutableArray alloc] init];
    
    withSelectMain=[[NSMutableArray alloc] init];
    withoutselectMain=[[NSMutableArray alloc] init];
    for (NSMutableArray *dic1 in ProductIngredDic)
    {
        if ([[dic1 valueForKey:@"is_with"] boolValue]==0)
        {
            [withoutIntegrate addObject:dic1];
        }
        else
        {
             [WithIntegrate addObject:dic1];
        }
        count++;
    }
    
    
    WithSelectArr=[[NSMutableArray alloc]init];
    WithoutSelectArr=[[NSMutableArray alloc]init];
    for (int i=0; i<withoutIntegrate.count; i++)
    {
        [WithoutSelectArr addObject:@"NO"];
    }
    for (int i=0; i<WithIntegrate.count; i++)
    {
        [WithSelectArr addObject:@"NO"];
    }
    [WithoutTBL reloadData];
    [WithTBL reloadData];
    NSLog(@"withoutIntegrate=%@",withoutIntegrate);
    
}

- (IBAction)Cancle:(id)sender
{
        OptionView.hidden=YES;
    [WithTBL reloadData];
    [WithoutTBL reloadData];
}

-(void)checkLoginAndPresentContainer
{
    LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
    vcr.ShowBack=@"YES";
    [self.navigationController  pushViewController:vcr animated:YES];
}

- (IBAction)Confirm_Click:(id)sender
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    if ([KmyappDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        for (int i=0; i<withSelectMain.count; i++)
        {
            [arr addObject:[WithIntegrate objectAtIndex:[[withSelectMain objectAtIndex:i] integerValue]]];
        }
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        for (int i=0; i<withoutselectMain.count; i++)
        {
            [arr2 addObject:[withoutIntegrate objectAtIndex:[[withoutselectMain objectAtIndex:i] integerValue]]];
        }
        
        NSArray *FinalArray=[arr arrayByAddingObjectsFromArray:arr2];
        OptionView.hidden=YES;
        [WithTBL reloadData];
        [WithoutTBL reloadData];
        
//        NSString *prductNM=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:subItemIndex];
//        NSString *prductPRICE=[[subCategoryDic valueForKey:@"price"] objectAtIndex:subItemIndex];
        NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:subItemIndex];
        NSString *Productid=[[subCategoryDic valueForKey:@"id"] objectAtIndex:subItemIndex];
        
        NSArray *CategoryIdArr=[KmyappDelegate.MainCartArr valueForKey:@"CategoryId"];
        NSLog(@"=== %@",KmyappDelegate.MainCartArr);
        if ([CategoryIdArr containsObject:CategoryId])
        {
            NSArray *ProductidArr=[KmyappDelegate.MainCartArr valueForKey:@"Productid"];
            if ([ProductidArr containsObject:Productid])
            {
                for (int i=0; i<ProductidArr.count; i++)
                {
                    if ([[[KmyappDelegate.MainCartArr valueForKey:@"Productid"] objectAtIndex:i] isEqualToString:Productid])
                    {
                        NSArray *ingredientArr=[[KmyappDelegate.MainCartArr valueForKey:@"ingredient"] objectAtIndex:i];
                        if ([ingredientArr isKindOfClass:[NSArray class]])
                        {
                            NSSet *set1 = [NSSet setWithArray:ingredientArr];
                            NSSet *set2 = [NSSet setWithArray:FinalArray];
                            
                            if([set1 isEqualToSet:set2])
                            {
                                NSString *addqnt=[NSString stringWithFormat:@"%d",[Quatity integerValue]+[[[KmyappDelegate.MainCartArr valueForKey:@"quatity"] objectAtIndex:i] integerValue]];
                                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                                NSDictionary *oldDict = (NSDictionary *)[KmyappDelegate.MainCartArr objectAtIndex:i];
                                [newDict addEntriesFromDictionary:oldDict];
                                [newDict setObject:addqnt forKey:@"quatity"];
                                [KmyappDelegate.MainCartArr replaceObjectAtIndex:i withObject:newDict];
                                [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
                                KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
                                [AppDelegate showErrorMessageWithTitle:@"" message:@"Product Added in Cart." delegate:nil];
                                
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
                                
                                break;
                            }
                            else
                            {
                                if (i==ProductidArr.count-1)
                                {
                                    NSLog(@"Not Same");
                                    [self Addcartdatawithoption:FinalArray];
                                    break;
                                }
                            }
                        }
                        else
                        {
                            if (i==ProductidArr.count-1)
                            {
                                NSLog(@"Not Same");
                                [self Addcartdatawithoption:FinalArray];
                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                [self Addcartdatawithoption:FinalArray];
            }
        }
        else
        {
            [self Addcartdatawithoption:FinalArray];
        }
    }
}

-(void)Addcartdatawithoption :(NSArray *)finalArr
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    NSString *prductNM=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:subItemIndex];
    NSString *prductPRICE=[[subCategoryDic valueForKey:@"price"] objectAtIndex:subItemIndex];
    NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:subItemIndex];
    NSString *Productid=[[subCategoryDic valueForKey:@"id"] objectAtIndex:subItemIndex];
    
    NSMutableDictionary *AddTocardDic = [[NSMutableDictionary alloc] init];
    [AddTocardDic setObject:prductNM forKey:@"productName"];
    [AddTocardDic setObject:prductPRICE forKey:@"price"];
    [AddTocardDic setObject:Quatity forKey:@"quatity"];
    [AddTocardDic setObject:Productid forKey:@"Productid"];
    [AddTocardDic setObject:CategoryId forKey:@"CategoryId"];
    
    [AddTocardDic setObject:finalArr forKey:@"ingredient"];
    NSLog(@"AddTocardDic===%@",AddTocardDic);
    
    KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    [KmyappDelegate.MainCartArr addObject:AddTocardDic];
    [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
    NSLog(@"==%@",KmyappDelegate.MainCartArr);
    [AppDelegate showErrorMessageWithTitle:@"" message:@"Product Added in Cart." delegate:nil];
    
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


#pragma mark - SerachBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    HeaderViewHight.constant=190;
    HraderTitleY.constant=40;
    searchBar.hidden=YES;
    
    subCategoryDic=[Searchdic mutableCopy];
    [SearchBR resignFirstResponder];
    [ItemTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    HeaderViewHight.constant=98;
    HraderTitleY.constant=3;
    
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [ItemTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    subCategoryDic=[Searchdic mutableCopy];
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        subCategoryDic=[Searchdic mutableCopy];
        [ItemTableView reloadData];
        return;
    }
    
    NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in subCategoryDic)
    {
        NSString *wineName = [wine objectForKey:@"productName"];
        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    subCategoryDic=[resultObjectsArray mutableCopy];
    [ItemTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    subCategoryDic=[Searchdic mutableCopy];
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
    {
        subCategoryDic=[Searchdic mutableCopy];
        [ItemTableView reloadData];
        return;
    }
    NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in subCategoryDic)
    {
        NSString *wineName = [wine objectForKey:@"productName"];
        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    subCategoryDic=[resultObjectsArray mutableCopy];
    [ItemTableView reloadData];
    [searchBar resignFirstResponder];
}

- (IBAction)Search_Click:(id)sender
{
    SearchBR.hidden=NO;
    SearchBR.text=@"";
    [SearchBR becomeFirstResponder];
}

@end
