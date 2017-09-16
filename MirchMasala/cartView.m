//
//  cartView.m
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "cartView.h"
#import "CartTableCell.h"
#import "CartGrandTotalCell.h"
#import "LoginVW.h"
#import "CheckOut_AddressVIEW.h"
#import "CommentTextCell.h"

@interface cartView ()
{
    NSString *CoustmerID,*MainDiscount,*CategoryIdStr,*Select_Indx;
    
    float tempMainTotal;
    float tempTotal;
    
    
    NSMutableArray *WithSelectArr,*WithoutSelectArr;
    NSMutableArray *withSelectMain,*withoutselectMain;
}
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;

@end

@implementation cartView
@synthesize cartTable;
@synthesize arr,dic,MainCount,CheckoutTotal_LBL;
@synthesize OptionView,WithTBL,WithoutTBL,Notavailable_LBL,cartNotification_LBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cartNotification_LBL.layer.masksToBounds = YES;
    cartNotification_LBL.layer.cornerRadius = 8.0f;
    
    OptionView.hidden=YES;
    self.OptionTitleView.layer.masksToBounds = NO;
    self.OptionTitleView.layer.shadowOffset = CGSizeMake(0, 1);
    self.OptionTitleView.layer.shadowOpacity = 0.5;
    
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        
        NSLog( @"%@",KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]]);
        
        Notavailable_LBL.hidden=YES;
        cartTable.hidden=NO;
        cellcount=KmyappDelegate.MainCartArr.count;
        [cartNotification_LBL setHidden:NO];
        
        NSInteger qnttotal=0;
        for (int i=0; i<KmyappDelegate.MainCartArr.count; i++)
        {
            qnttotal=qnttotal+[[[KmyappDelegate.MainCartArr objectAtIndex:i]valueForKey:@"quatity"] integerValue];
        }
        
        cartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
        
        ExtraCellINT=1;
    }
    else
    {
        Notavailable_LBL.hidden=NO;
        cartTable.hidden=YES;
        [cartNotification_LBL setHidden:YES];
        ExtraCellINT=0;
    }
    
    UINib *nib = [UINib nibWithNibName:@"CartTableCell" bundle:nil];
    CartTableCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell.frame.size.height;
    [cartTable registerNib:nib forCellReuseIdentifier:@"CartTableCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"CartGrandTotalCell" bundle:nil];
    CartGrandTotalCell *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell1.frame.size.height;
    [cartTable registerNib:nib1 forCellReuseIdentifier:@"CartGrandTotalCell"];
    
    UINib *nib3 = [UINib nibWithNibName:@"CommentTextCell" bundle:nil];
    CommentTextCell *cell2 = [[nib3 instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell2.frame.size.height;
    [cartTable registerNib:nib3 forCellReuseIdentifier:@"CommentTextCell"];
    
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        arr = [[NSMutableArray alloc] init];
        for (int i = 0; i <KmyappDelegate.MainCartArr.count; i++)
        {
            [arr addObject:@"1"];
        }
        
        dic=[[NSMutableDictionary alloc]init];
        MainCount=[[NSMutableDictionary alloc]init];
        [dic setObject:arr forKey:@"Count"];
        [MainCount setObject:arr forKey:@"MainCount"];
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self GetDiscount];
            //[self CalculateGrantTotal];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}

-(void)CalculateGrantTotal
{
    tempMainTotal=0.00;
    tempTotal=0.00;
    for (int jj=0; jj<KmyappDelegate.MainCartArr.count; jj++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:jj] valueForKey:@"ingredient"] mutableCopy];
        
        tempTotal=[[[KmyappDelegate.MainCartArr objectAtIndex:jj]valueForKey:@"price"] floatValue];
        float integratPRICE=0.00;
        NSLog(@"Array==%@",Array);
        if ([Array isKindOfClass:[NSArray class]])
        {
            NSString *WithoutStr=[[NSString alloc]init];
            NSString *WithStr=[[NSString alloc]init];
            
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] boolValue]==0)
                {
                    integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price_without"] floatValue];
                    
                    if ([WithoutStr isEqualToString:@""])
                    {
                        WithoutStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                    }
                    else
                    {
                        WithoutStr=[NSString stringWithFormat:@"%@,%@",WithoutStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                    }
                }
                else
                {
                    integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
                    
                    if ([WithStr isEqualToString:@""])
                    {
                        WithStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                    }
                    else
                    {
                        WithStr=[NSString stringWithFormat:@"%@,%@",WithStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                    }
                }
            }
           NSLog(@"integratPRICE==%f",integratPRICE);
        }
       // NSLog(@"Price total=%f",Total);
        tempTotal=tempTotal*[[[KmyappDelegate.MainCartArr objectAtIndex:jj]valueForKey:@"quatity"] floatValue];
        
        //NSLog(@"total=%f",Total);
        float QUATIntegate=integratPRICE*[[[KmyappDelegate.MainCartArr objectAtIndex:jj]valueForKey:@"quatity"] floatValue];
        NSLog(@"QUATIntegate=%f",QUATIntegate);
        tempMainTotal=tempMainTotal+tempTotal+QUATIntegate;
    }
    float Calution=tempMainTotal-[MainDiscount floatValue];
    CheckoutTotal_LBL.text=[NSString stringWithFormat:@"£%.02f",Calution];
    NSLog(@"tempTotal=%f",tempTotal);
    NSLog(@"tempMainTotal=%f",tempMainTotal);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
}

-(void)SUBCategoriesList :(NSString *)CategoryId buttonTag:(NSString *)ProductidStr Selecredinx:(NSString *)Selectcredinx
{
    [KVNProgress show] ;
    CategoryIdStr=CategoryId;
    Select_Indx=Selectcredinx;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:CategoryId forKey:@"CATEGORYID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"products" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             subCategoryDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"products"];
             
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
             
             NSArray *idarr=[subCategoryDic valueForKey:@"id"];
             NSInteger indx=[idarr indexOfObject:ProductidStr];
             
             NSLog(@"==%@",[KmyappDelegate.MainCartArr objectAtIndex:[Selectcredinx integerValue]]);
             NSArray *ingredientArr=[[KmyappDelegate.MainCartArr valueForKey:@"ingredient"] objectAtIndex:[Selectcredinx integerValue]];
             if ([ingredientArr isKindOfClass:[NSArray class]])
             {
                 if (ingredientArr.count>0)
                 {
                     [self OptionClick:[NSString stringWithFormat:@"%ld",(long)indx] :ingredientArr];
                 }
                 else
                 {
                     [self OptionClick:[NSString stringWithFormat:@"%ld",(long)indx] :@""];
                 }
             }
             else
             {
                 [self OptionClick:[NSString stringWithFormat:@"%ld",(long)indx] :@""];
             }
             
             
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

-(void)OptionClick:(NSString *)indextag : (NSArray *)IntgArr;
{
    OptionView.hidden=NO;
    subItemIndex= [indextag integerValue];
    ProductIngredDic=[[subCategoryDic valueForKey:@"ingredients"] objectAtIndex:subItemIndex];
    
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
    
    if ([IntgArr isKindOfClass:[NSArray class]])
    {
        for (int i=0; i<IntgArr.count; i++)
        {
            NSString *ingredient_idStr=[[IntgArr objectAtIndex:i] valueForKey:@"ingredient_id"];
            NSArray *filtered = [IntgArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ingredient_id == %@)", ingredient_idStr]];
            for (int k=0; k<filtered.count; k++)
            {
                if ([[[filtered objectAtIndex:k] valueForKey:@"is_with"] isEqualToString:@"1"])
                {
                    NSInteger indx=[[WithIntegrate valueForKey:@"ingredient_id"] indexOfObject:[[filtered objectAtIndex:k] valueForKey:@"ingredient_id"]];
                    [WithSelectArr replaceObjectAtIndex:indx withObject:@"YES"];
                    
                    if ([[WithSelectArr objectAtIndex:indx] isEqualToString:@"YES"])
                    {
                        [WithSelectArr replaceObjectAtIndex:indx withObject:@"YES"];
                        if (![withSelectMain containsObject:[NSString stringWithFormat:@"%ld",indx]])
                        {
                            [withSelectMain addObject:[NSString stringWithFormat:@"%ld",indx]];
                        }
                        
                    }
                    else
                    {
                        [WithSelectArr replaceObjectAtIndex:indx withObject:@"NO"];
                        [withSelectMain removeObjectAtIndex:indx];
                        
                    }
                }
                else
                {
                    NSInteger indx=[[withoutIntegrate valueForKey:@"ingredient_id"] indexOfObject:[[filtered objectAtIndex:k] valueForKey:@"ingredient_id"]];
                    [WithoutSelectArr replaceObjectAtIndex:indx withObject:@"YES"];
                    
                    if ([[WithoutSelectArr objectAtIndex:indx] isEqualToString:@"YES"])
                    {
                        [WithoutSelectArr replaceObjectAtIndex:indx withObject:@"YES"];
                        if (![withoutselectMain containsObject:[NSString stringWithFormat:@"%ld",indx]])
                        {
                            [withoutselectMain addObject:[NSString stringWithFormat:@"%ld",(long)indx]];
                        }
                    }
                    else
                    {
                        [WithoutSelectArr replaceObjectAtIndex:indx withObject:@"NO"];
                        [withoutselectMain removeObjectAtIndex:indx];
                    }
                }
            }
        }
    }
    else
    {
        for (int i=0; i<withoutIntegrate.count; i++)
        {
            [WithoutSelectArr addObject:@"NO"];
        }
        for (int i=0; i<WithIntegrate.count; i++)
        {
            [WithSelectArr addObject:@"NO"];
        }

    }
    [WithoutTBL reloadData];
    [WithTBL reloadData];
    NSLog(@"withoutIntegrate=%@",withoutIntegrate);
    
}

-(void)GetDiscount
{
    [KVNProgress show] ;
    
    MainDiscount =@"0.00";
    NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
    //NSLog(@"===%@",KmyappDelegate.MainCartArr);
    for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredient"] mutableCopy];
        NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
        NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
        NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
        
        //ProdArr=[[NSMutableArray alloc]init];
        NSString *ProdidSr=[[NSString alloc]init];
        if ([Array isKindOfClass:[NSArray class]])
        {
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] isEqualToString:@"1"])
                {
                    [Withindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                else
                {
                    [Withoutindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                ProdidSr=[[Array objectAtIndex:i] valueForKey:@"product_id"];
            }
            if (Withindgarr.count>0)
            {
                [inddic setObject:Withindgarr forKey:@"WITHINGREDIENTID"];
            }
            if (Withoutindgarr.count>0)
            {
                [inddic setObject:Withoutindgarr forKey:@"WITHOUTINGREDIENTID"];
            }
        }
        
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"Productid"] forKey:@"ID"];
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"quatity"] forKey:@"QUANTITY"];
        [ProdArr addObject:inddic];
    }
    
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:@"collection" forKey:@"ORDERTYPE"];
    [dictInner setObject:ProdArr forKey:@"PRODUCTS"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"calculateDiscount" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
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
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"calculateDiscount"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             MainDiscount=[NSString stringWithFormat:@"%@",[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"calculateDiscount"]  objectForKey:@"result"] objectForKey:@"calculateDiscount"]];
            [self CalculateGrantTotal];
             [cartTable reloadData];
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
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 1;
    }
    //NSLog(@"MainCartArr---%d",KmyappDelegate.MainCartArr.count);
    return KmyappDelegate.MainCartArr.count+ExtraCellINT+1;
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
    return 10;
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
        static NSString *CellIdentifier1 = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
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
    else
    {
        
        if (indexPath.section == cellcount)
        {
            static NSString *CellIdentifier = @"CartGrandTotalCell";
            CartGrandTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell=nil;
            if (cell == nil)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            cell.SubTotal_LBL.text=[NSString stringWithFormat:@"£%.02f",tempMainTotal];
            cell.Discount_LBL.text=[NSString stringWithFormat:@"£%@",MainDiscount];
            float Gt = tempMainTotal - [MainDiscount floatValue];
            NSLog(@"Gt==%f",Gt);
            GandTotal=Gt;
            cell.GrandTotal_LBL.text=[NSString stringWithFormat:@"£%.02f",Gt];
            //CheckoutTotal_LBL.text=[NSString stringWithFormat:@"%@",cell.GrandTotal_LBL.text];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else if(indexPath.section == cellcount+1)
        {
            static NSString *CellIdentifier1 = @"Cell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell=nil;
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.accessoryView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UILabel *clearCart=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cartTable.frame.size.width, 44)];
            clearCart.text=@"Clear Cart";
            clearCart.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
            clearCart.textAlignment=NSTextAlignmentCenter;
            [cell addSubview:clearCart];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }/*
        else if(indexPath.section == cellcount)
        {
            static NSString *CellIdentifier = @"CommentTextCell";
            CommentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell=nil;
            if (cell == nil)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }*/

        else
        {
            
            static NSString *CellIdentifier = @"CartTableCell";
            CartTableCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell1=nil;
            if (cell1 == nil)
            {
                cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section] valueForKey:@"ingredient"] mutableCopy];
            
             float integratPRICE=0.00;
            if ([Array isKindOfClass:[NSArray class]])
            {
                NSString *WithoutStr=[[NSString alloc]init];
                NSString *WithStr=[[NSString alloc]init];
               
                for (int i=0; i<Array.count; i++)
                {
                    if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] boolValue]==0)
                    {
                        integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price_without"] floatValue];
                        
                        if ([WithoutStr isEqualToString:@""])
                        {
                            WithoutStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                        }
                        else
                        {
                            WithoutStr=[NSString stringWithFormat:@"%@,%@",WithoutStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                        }
                    }
                    else
                    {
                        integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
                        
                        if ([WithStr isEqualToString:@""])
                        {
                            WithStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                        }
                        else
                        {
                            WithStr=[NSString stringWithFormat:@"%@,%@",WithStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                        }
                    }
                }
                
                // Without Lable
                if ([WithoutStr isEqualToString:@""])
                {
                    cell1.WithoutOptiion_LBL.text=@"--";
                }
                else
                {
                    cell1.WithoutOptiion_LBL.text=WithoutStr;
                }
                
                // With Lable
                if ([WithStr isEqualToString:@""])
                {
                    cell1.WithOption_LBL.text=@"--";
                }
                else
                {
                    cell1.WithOption_LBL.text=WithStr;
                }
            }
            else
            {
                cell1.WithoutOptiion_LBL.text=@"--";
                cell1.WithOption_LBL.text=@"--";
            }
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell1.Title_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"productName"];
            
            cell1.Qnt_TXT.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"quatity"];
            cell1.Qnt_TXT.tag=indexPath.section;
            cell1.Price_LBL.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"price"]];
            
            [cell1.Close_BTN addTarget:self action:@selector(Close_Click:) forControlEvents:UIControlEventTouchUpInside];
            cell1.Close_BTN.tag=indexPath.section;
            
            [cell1.Update_BTN addTarget:self action:@selector(Update_Click:) forControlEvents:UIControlEventTouchUpInside];
            cell1.Update_BTN.tag=indexPath.section;

            [cell1.Change_BTN addTarget:self action:@selector(Change_Click:) forControlEvents:UIControlEventTouchUpInside];
            cell1.Change_BTN.tag=indexPath.section;

            return cell1;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 44;
    }
    else
    {
        if (indexPath.section == cellcount)
        {
            return 130;
        }/*
        else if (indexPath.section==cellcount+1)
        {
            return 137;
        }*/
        else if (indexPath.section==cellcount+1)
        {
            return 44;
        }
        else
        {
            return 100;
        }
        
    }    
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
    else if (indexPath.section==cellcount+1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                       message: @"Are you want to clear cart?"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
        [alert setTag:1];
        [alert show];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            NSLog(@"user pressed Button Indexed 0");
            // Any action can be performed here
        }
        else
        {
            [KmyappDelegate.MainCartArr removeAllObjects];
            KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
            [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
            KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
            cellcount=KmyappDelegate.MainCartArr.count;
            
            [cartTable reloadData];
            if (KmyappDelegate.MainCartArr.count>0)
            {
                Notavailable_LBL.hidden=YES;
                cartTable.hidden=NO;
                
                [cartNotification_LBL setHidden:NO];
                NSInteger qnttotal=0;
                for (int i=0; i<KmyappDelegate.MainCartArr.count; i++)
                {
                    qnttotal=qnttotal+[[[KmyappDelegate.MainCartArr objectAtIndex:i]valueForKey:@"quatity"] integerValue];
                }
                cartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
                //[self CalculateGrantTotal];
            }
            else
            {
                Notavailable_LBL.hidden=NO;
                cartTable.hidden=YES;
                
                [cartNotification_LBL setHidden:YES];
                [self CalculateGrantTotal];
            }

        }
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

- (IBAction)Cancle_Click:(id)sender
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
   
    
    if ([KmyappDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
        NSMutableArray *arrs=[[NSMutableArray alloc]init];
        for (int i=0; i<withSelectMain.count; i++)
        {
            [arrs addObject:[WithIntegrate objectAtIndex:[[withSelectMain objectAtIndex:i] integerValue]]];
        }
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        for (int i=0; i<withoutselectMain.count; i++)
        {
            [arr2 addObject:[withoutIntegrate objectAtIndex:[[withoutselectMain objectAtIndex:i] integerValue]]];
        }
        
        NSArray *FinalArray=[arrs arrayByAddingObjectsFromArray:arr2];
        OptionView.hidden=YES;
        [WithTBL reloadData];
        [WithoutTBL reloadData];
        
        NSString *prductNM=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:subItemIndex];
        NSString *prductPRICE=[[subCategoryDic valueForKey:@"price"] objectAtIndex:subItemIndex];
        NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:subItemIndex];
        NSString *Productid=[[subCategoryDic valueForKey:@"id"] objectAtIndex:subItemIndex];
        
        NSMutableDictionary *AddTocardDic = [[NSMutableDictionary alloc] init];
        [AddTocardDic setObject:prductNM forKey:@"productName"];
        [AddTocardDic setObject:prductPRICE forKey:@"price"];
        [AddTocardDic setObject:Quatity forKey:@"quatity"];
        [AddTocardDic setObject:Productid forKey:@"Productid"];
        [AddTocardDic setObject:CategoryIdStr forKey:@"CategoryId"];
        
        [AddTocardDic setObject:FinalArray forKey:@"ingredient"];
        NSLog(@"AddTocardDic===%@",AddTocardDic);
        
        NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
        NSString *CoustmerIDs=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerIDs]];
        [KmyappDelegate.MainCartArr removeObjectAtIndex:[Select_Indx integerValue]];
        [KmyappDelegate.MainCartArr insertObject:AddTocardDic atIndex:[Select_Indx integerValue]];

       // [KmyappDelegate.MainCartArr addObject:AddTocardDic];
        [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerIDs];
        NSLog(@"==%@",KmyappDelegate.MainCartArr);
        
        [self GetDiscount];
        [self CalculateGrantTotal];
        [cartTable reloadData];
      
    }
}

-(void)Change_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    [self SUBCategoriesList:[[KmyappDelegate.MainCartArr objectAtIndex:senderButton.tag] valueForKey:@"CategoryId"] buttonTag:[[KmyappDelegate.MainCartArr objectAtIndex:senderButton.tag] valueForKey:@"Productid"] Selecredinx:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
}

-(void)Update_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:0 inSection:senderButton.tag];
    CartTableCell *cell = (CartTableCell *)[cartTable cellForRowAtIndexPath:changedRow];
    
    if (![cell.Qnt_TXT.text isEqualToString:@"0"] && ![cell.Qnt_TXT.text isEqualToString:@""])
    {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[KmyappDelegate.MainCartArr objectAtIndex:senderButton.tag];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:cell.Qnt_TXT.text forKey:@"quatity"];
        [KmyappDelegate.MainCartArr replaceObjectAtIndex:senderButton.tag withObject:newDict];
        [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
        [self GetDiscount];
        [self CalculateGrantTotal];
        [cartTable reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Invalid Quatity Number." delegate:nil];
        [cartTable reloadData];
    }
    
    
}

-(void)Close_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    [KmyappDelegate.MainCartArr removeObjectAtIndex:senderButton.tag];
    [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
    KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    cellcount=KmyappDelegate.MainCartArr.count;
    
     [self GetDiscount];
    [cartTable reloadData];
    
    if (KmyappDelegate.MainCartArr.count>0)
    {
        Notavailable_LBL.hidden=YES;
        cartTable.hidden=NO;

        NSInteger qnttotal=0;
        for (int i=0; i<KmyappDelegate.MainCartArr.count; i++)
        {
            qnttotal=qnttotal+[[[KmyappDelegate.MainCartArr objectAtIndex:i]valueForKey:@"quatity"] integerValue];
        }
        
        [cartNotification_LBL setHidden:NO];
        cartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
    }
    else
    {
        Notavailable_LBL.hidden=NO;
        cartTable.hidden=YES;

        [cartNotification_LBL setHidden:YES];
    }
}

- (IBAction)CheckOutBtn_Action:(id)sender
{
    //NSIndexPath *changedRow = [NSIndexPath indexPathForRow:0 inSection:cellcount];
   // CommentTextCell *cell = (CommentTextCell *)[cartTable cellForRowAtIndexPath:changedRow];
   // NSLog(@"===%@",cell.Comment_TXT.text);
    
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            CheckOut_AddressVIEW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckOut_AddressVIEW"];
            NSString *stringWithoutSpaces = [CheckoutTotal_LBL.text
                                             stringByReplacingOccurrencesOfString:@"£" withString:@""];
            vcr.CartTotalAmout=stringWithoutSpaces;
           // vcr.Comment1View=cell.Comment_TXT.text;
            [self.navigationController pushViewController:vcr animated:YES];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ToggleMenuBtn_action:(id)sender
{
    //[self.rootNav drawerToggle];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}


@end
