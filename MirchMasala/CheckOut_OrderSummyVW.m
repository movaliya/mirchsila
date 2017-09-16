//
//  CheckOut_OrderSummyVW.m
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "CheckOut_OrderSummyVW.h"
#import "OrderSummay_Detail.h"
#import "OrderSummry_Total.h"
#import "CheckOut_PaymentVW.h"
#import "MYCartVW.h"

@interface CheckOut_OrderSummyVW ()<UITextViewDelegate>
{
    float GetTotal,GetMainTotal;
    NSString *MainDiscount;
}

@end

@implementation CheckOut_OrderSummyVW
@synthesize TableVW,CartNotification_LBL,paymentBtn,deliveryCharge1;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [paymentBtn.layer setCornerRadius:20.0f];
    [paymentBtn.layer setMasksToBounds:YES];
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
         cellcount=KmyappDelegate.MainCartArr.count;
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
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    
    UINib *nib = [UINib nibWithNibName:@"OrderSummay_Detail" bundle:nil];
    OrderSummay_Detail *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TableVW.rowHeight = cell.frame.size.height;
    [TableVW registerNib:nib forCellReuseIdentifier:@"OrderSummay_Detail"];
    
    UINib *nib1 = [UINib nibWithNibName:@"OrderSummry_Total" bundle:nil];
    OrderSummry_Total *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TableVW.rowHeight = cell1.frame.size.height;
    [TableVW registerNib:nib1 forCellReuseIdentifier:@"OrderSummry_Total"];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self performSelector:@selector(GetDiscountmethod) withObject:nil afterDelay:0.1];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
 
}

-(void)CalculateGrantTotal
{
    GetMainTotal=0.00;
    GetTotal=0.00;
    for (int jj=0; jj<KmyappDelegate.MainCartArr.count; jj++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:jj] valueForKey:@"ingredient"] mutableCopy];
        
        GetTotal=[[[KmyappDelegate.MainCartArr objectAtIndex:jj]valueForKey:@"price"] floatValue];
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
        GetTotal=GetTotal*[[[KmyappDelegate.MainCartArr objectAtIndex:jj]valueForKey:@"quatity"] floatValue];
        
        //NSLog(@"total=%f",Total);
        float QUATIntegate=integratPRICE*[[[KmyappDelegate.MainCartArr objectAtIndex:jj]valueForKey:@"quatity"] floatValue];
        NSLog(@"QUATIntegate=%f",QUATIntegate);
        GetMainTotal=GetMainTotal+GetTotal+QUATIntegate;
    }
    NSLog(@"GetTotal=%f",GetTotal);
    NSLog(@"GetMainTotal=%f",GetMainTotal);
    
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  return topCategoriesDic.count;
    return KmyappDelegate.MainCartArr.count+1;
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
    if (indexPath.section == cellcount)
    {
        static NSString *CellIdentifier = @"OrderSummry_Total";
        OrderSummry_Total *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell1=nil;
        if (cell1 == nil)
        {
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell1.Discount_LBL.text=[NSString stringWithFormat:@"£%@",MainDiscount];
        float Gt=[[NSString stringWithFormat:@"%.02f",GetMainTotal] floatValue] - [MainDiscount floatValue];
        
        cell1.OrderAmount_LBL.text=[NSString stringWithFormat:@"£%.02f",Gt];
       
        cell1.Comment_TXT.layer.cornerRadius=5.0f;
        cell1.Comment_TXT.layer.borderWidth=0.5;
        cell1.Comment_TXT.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        cell1.Comment_TXT.delegate=self;
        
        return cell1;
    }
    else
    {
        static NSString *CellIdentifier = @"OrderSummay_Detail";
        OrderSummay_Detail *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
       
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
                cell.Without_LBL.text=@"--";
            }
            else
            {
                cell.Without_LBL.text=WithoutStr;
            }
            
            // With Lable
            if ([WithStr isEqualToString:@""])
            {
                cell.With_LBL.text=@"--";
            }
            else
            {
                cell.With_LBL.text=WithStr;
            }
        }
        else
        {
            cell.Without_LBL.text=@"--";
            cell.With_LBL.text=@"--";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.ProductName_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"productName"];
        
       // NSLog(@"MainCartArr=%@",cell.ProductPrice_LBL.text);
        
        cell.Quatity_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"quatity"];
        cell.Quatity_LBL.tag=indexPath.section;
        cell.ProductPrice_LBL.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"price"]];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 13)
    {
        return 68;
    }
    else if (indexPath.section==cellcount)
    {
        return 201;

    }
    return 84;
    
}

-(void)GetDiscountmethod
{
    [KVNProgress show] ;
    MainDiscount =@"0.00";
    NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
    NSLog(@"===%@",KmyappDelegate.MainCartArr);
    for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredient"] mutableCopy];
        NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
        NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
        NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
        
       // ProdArr=[[NSMutableArray alloc]init];
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
    
    [dictInner setObject:@"Collection" forKey:@"ORDERTYPE"];
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
    
    NSLog(@"json===%@",json);
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
              NSLog(@"responseObjectjson===%@",responseObject);
             MainDiscount=[NSString stringWithFormat:@"%@",[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"calculateDiscount"]  objectForKey:@"result"] objectForKey:@"calculateDiscount"]];
             [self CalculateGrantTotal];
             [TableVW reloadData];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

- (IBAction)PaymentMethod_Action:(id)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:0 inSection:cellcount];
     OrderSummry_Total *cell = (OrderSummry_Total *)[TableVW cellForRowAtIndexPath:changedRow];
     NSLog(@"===%@",cell.Comment_TXT.text);
    [KVNProgress dismiss];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        CheckOut_PaymentVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckOut_PaymentVW"];
        vcr.Discount=[NSString stringWithFormat:@"%@",MainDiscount];
        vcr.OrderAmount=[NSString stringWithFormat:@"%.02f",GetMainTotal];
        vcr.deliveryCharge=deliveryCharge1;
        vcr.Comment3View=cell.Comment_TXT.text;
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   
}

- (IBAction)TopBarCartBtn_action:(id)sender
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    if (CoustmerID!=nil)
    {
        MYCartVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MYCartVW"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}


@end
