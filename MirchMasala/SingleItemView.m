//
//  SignleItemView.m
//  MirchMasala
//
//  Created by kaushik on 10/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SingleItemView.h"
#import "MirchMasala.pch"
#import "cartView.h"

@interface SingleItemView ()
{
    NSMutableArray *WithSelectArr,*WithoutSelectArr;
    NSMutableArray *withSelectMain,*withoutselectMain;
    NSMutableDictionary *AllProductIngredientsDIC;
    NSMutableArray *WithIntegrate,*withoutIntegrate;
    NSMutableDictionary *ProductIngredDic;

    NSMutableArray *arrayInt;


}
@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;

@end

@implementation SingleItemView
@synthesize Price_LBL,BackView,Title_LBL,OptionBTN,ItemArr,Qnt_LBL,CartNotification_LBL;
@synthesize dic,MainCount,OptionView,OptionTitleView,WithTBL,WithoutTBL,CategoryId;
@synthesize BannerImageView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    OptionBTN.layer.cornerRadius=5;
    OptionBTN.layer.masksToBounds=YES;
    
    BackView.layer.borderColor= [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.borderWidth=0.5;
    BackView.layer.cornerRadius=3;
    BackView.layer.masksToBounds = NO;
    BackView.layer.shadowOffset = CGSizeMake(0, 1);
    BackView.layer.shadowRadius = 0.2;
    BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.shadowOpacity = 0.2;
    
    NSMutableDictionary *TempProductIngredDic=[ItemArr valueForKey:@"ingredients"];
    if (TempProductIngredDic.count==0)
    {
        NSLog(@"Option Btn Hidden");
        OptionBTN.hidden=YES;
    }
    else
    {
        OptionBTN.hidden=NO;
    }
    
   // NSString *description=[ItemArr valueForKey:@"description"];
    
    if ([ItemArr valueForKey:@"description"] != (id)[NSNull null])
    {
        self.backview_hieght.constant=130;
        self.Description_lbl.hidden=NO;
        self.Description_lbl.text=[ItemArr valueForKey:@"description"];
        self.ViewBottomSpace.constant=50;
    }
    else
    {
        self.backview_hieght.constant=80;
         self.ViewBottomSpace.constant=8;
        self.Description_lbl.hidden=YES;
    }
    
    
    NSString *Urlstr=[ItemArr valueForKey:@"imagePath"];
    
    [BannerImageView sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"slider_image_1.png"]];
    [BannerImageView setShowActivityIndicatorView:YES];
    
    NSMutableDictionary *TempProductIngredDic1=[ItemArr valueForKey:@"ingredients"];
    arrayInt = [[NSMutableArray alloc] init];
    if (TempProductIngredDic1.count!=0)
    {
        AllProductIngredientsDIC=[[ItemArr valueForKey:@"ingredients"] objectAtIndex:0];
        
        for (int i = 0; i <ItemArr.count; i++)
        {
            [arrayInt addObject:@"1"];
        }
    }
    else
    {
        [arrayInt addObject:@"1"];
    }
    dic=[[NSMutableDictionary alloc]init];
    MainCount=[[NSMutableDictionary alloc]init];
    [dic setObject:arrayInt forKey:@"Count"];
    [MainCount setObject:arrayInt forKey:@"MainCount"];
    
    
    
    
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
    
    self.OptionTitleView.layer.masksToBounds = NO;
    self.OptionTitleView.layer.shadowOffset = CGSizeMake(0, 1);
    self.OptionTitleView.layer.shadowOpacity = 0.5;
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    NSInteger *Main=[[[MainCount valueForKey:@"MainCount"] objectAtIndex:0] integerValue];
    
    NSInteger *Second=[[[dic valueForKey:@"Count"] objectAtIndex:0] integerValue];
    
    if (Main==Second)
    {
        Qnt_LBL.text=[NSString stringWithFormat:@"%ld",Main];
    }
    else
    {
        Qnt_LBL.text=[NSString stringWithFormat:@"%ld",Second];
    }
    
    Title_LBL.text=[ItemArr valueForKey:@"productName"];
    Price_LBL.text=[NSString stringWithFormat:@"£%@",[ItemArr  valueForKey:@"price"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)checkLoginAndPresentContainer
{
    LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
    vcr.ShowBack=@"YES";
    [self.navigationController  pushViewController:vcr animated:YES];
}

- (IBAction)ItemCart_Click:(id)sender
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
        NSString *autoModify=[ItemArr valueForKey:@"autoModify"];
        NSLog(@"autoModify=%@",autoModify);
        if ([autoModify isEqualToString:@"1"])
        {
            [self Option_Click:sender];
            WithoutTBL.alpha=0.5f;
            autobool=YES;
        }
        else
        {
            autobool=NO;
            WithoutTBL.alpha=1;
            OptionView.hidden=YES;
            [WithTBL reloadData];
            [WithoutTBL reloadData];
            
            NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:senderButton.tag];
            NSString *Productid=[ItemArr valueForKey:@"id"];
            
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
                                NSString *addqnt=[NSString stringWithFormat:@"%ld",[Quatity integerValue]+[[[KmyappDelegate.MainCartArr valueForKey:@"quatity"] objectAtIndex:i] integerValue]];
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

}

-(void)Addnewitemincart :(NSInteger)btntag
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    NSString *prductNM=[ItemArr valueForKey:@"productName"];
    NSString *prductPRICE=[ItemArr valueForKey:@"price"] ;
    NSString *Quatity=[[MainCount valueForKey:@"MainCount"]objectAtIndex:btntag] ;
    NSString *Productid=[ItemArr valueForKey:@"id"];
    
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

- (IBAction)Option_Click:(id)sender
{
    OptionView.hidden=NO;
    ProductIngredDic=[ItemArr valueForKey:@"ingredients"];
    
    int count=0;
    withoutIntegrate=[[NSMutableArray alloc] init];
    WithIntegrate=[[NSMutableArray alloc] init];
    
    withSelectMain=[[NSMutableArray alloc] init];
    withoutselectMain=[[NSMutableArray alloc] init];
    NSString *autoModify=[ItemArr valueForKey:@"autoModify"] ;
    NSLog(@"autoModify=%@",autoModify);
    if ([autoModify isEqualToString:@"1"])
    {
        WithoutTBL.alpha=0.5f;
        autobool=YES;
    }
    else
    {
        autobool=NO;
        WithoutTBL.alpha=1;
    }
    
    
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

-(void)WithoutChkbox_click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld",(long)senderButton.tag);
    if (autobool==NO)
    {
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

- (IBAction)Minush_Click:(id)sender
{
    NSInteger count = [Qnt_LBL.text integerValue];
    count = count - 1;
    if (count!=0)
    {
        Qnt_LBL.text = [NSString stringWithFormat:@"%ld",(long)count];
        [arrayInt replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)count]];
        [dic setObject:arrayInt forKey:@"Count"];
        chechPlusMinus=0;
    }
}

- (IBAction)PlushBTN_Click:(id)sender
{
    
    NSInteger count = [Qnt_LBL.text integerValue];
    count = count + 1;
    Qnt_LBL.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    [arrayInt replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)count]];
    [dic setObject:arrayInt forKey:@"Count"];
    
    chechPlusMinus=1;
    
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TopCartBTN_Click:(id)sender
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



#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithoutTBL)
    {
        if (autobool==NO)
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
    return 44;
}

- (IBAction)Cancle:(id)sender
{
    OptionView.hidden=YES;
    [WithTBL reloadData];
    [WithoutTBL reloadData];
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
        
        if (autobool==YES)
        {
            if (FinalArray.count==0)
            {
                [AppDelegate showErrorMessageWithTitle:@"Alert!" message:@"Please select option" delegate:nil];
            }
            else
            {
                autobool=NO;
                OptionView.hidden=YES;
                [WithTBL reloadData];
                [WithoutTBL reloadData];
                NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:0];
                NSString *Productid=[ItemArr valueForKey:@"id"];
                
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
        else
        {
            OptionView.hidden=YES;
            [WithTBL reloadData];
            [WithoutTBL reloadData];
            NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:0];
            NSString *Productid=[ItemArr valueForKey:@"id"];
            
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
}

-(void)Addcartdatawithoption :(NSArray *)finalArr
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    NSString *prductNM=[ItemArr valueForKey:@"productName"];
    NSString *prductPRICE=[ItemArr valueForKey:@"price"];
    NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:0];
    NSString *Productid=[ItemArr valueForKey:@"id"];
    
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
@end
