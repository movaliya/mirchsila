//
//  OrderHistryView.m
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "OrderHistryView.h"
#import "OrderHistry_Cell.h"
#import "OrderDetailView.h"
#import "cartView.h"


@interface OrderHistryView ()
{
    NSMutableDictionary *CompleteOrderArr,*PendingOrderArr,*CancelOrderArr,*MainOrderHisrty;
}

@end

@implementation OrderHistryView
@synthesize OrderHistyTableView;
@synthesize CartNotification_LBL;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CompleteOrderArr=[[NSMutableDictionary alloc]init];
    PendingOrderArr=[[NSMutableDictionary alloc]init];
    CancelOrderArr=[[NSMutableDictionary alloc]init];
    
    
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
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 10.0f;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    UINib *nib = [UINib nibWithNibName:@"OrderHistry_Cell" bundle:nil];
    OrderHistry_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    OrderHistyTableView.rowHeight = cell.frame.size.height;
    [OrderHistyTableView registerNib:nib forCellReuseIdentifier:@"OrderHistry_Cell"];
     [cell.CancelBtn setHidden:YES];
    [cell.CancleIMG setHidden:YES];
    
    OrderStatus=@"Completed";
    
    // For tabbarView Shadow
    self.MenuView.layer.masksToBounds = NO;
    self.MenuView.layer.shadowOffset = CGSizeMake(0, 1);
   // self.MenuView.layer.shadowRadius = 5;
    self.MenuView.layer.shadowOpacity = 0.5;
    
    //Tab Bar Disable Object
    self.LBL_pending.backgroundColor=[UIColor whiteColor];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_cancel.backgroundColor=[UIColor whiteColor];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self GetOrderHistory];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
-(void)GetOrderHistory
{
    NSMutableDictionary *UserSaveData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    if (UserSaveData)
    {
        NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        
        [KVNProgress show] ;
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        
        [dictInner setObject:CoustmerID forKey:@"CUSTOMERID"];
        
        
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"orderHistory" forKey:@"METHOD"];
        
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
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
        
        [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         {
             
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderHistory"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 MainOrderHisrty=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderHistory"] objectForKey:@"result"];
                 
                 PendingOrderArr=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderHistory"] objectForKey:@"result"] objectForKey:@"orderHistory"];
                 //NSLog(@"OrderHistryResult=%@",PendingOrderArr);
                 [OrderHistyTableView reloadData];
             }
             else
             {
                 NSString *Errormsg=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderHistory"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
                 [AppDelegate showErrorMessageWithTitle:@"" message:Errormsg delegate:nil];
             }
             
             [KVNProgress dismiss] ;
         }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Fail");
             [KVNProgress dismiss] ;
         }];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"You are not Login." delegate:nil];
    }
    
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    /*
    NSInteger SectionIndex;
    if([OrderStatus isEqualToString:@"Completed"])
    {
        SectionIndex=CompleteOrderArr.count;
    }
    else if([OrderStatus isEqualToString:@"Pending"])
    {
        SectionIndex=PendingOrderArr.count;
    }
    else
    {
        SectionIndex=CancelOrderArr.count;
    }*/
    
    return PendingOrderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"OrderHistry_Cell";
    OrderHistry_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    if ([OrderStatus isEqualToString:@"Pending"])
    {
        [cell.CancelBtn setHidden:NO];
        [cell.CancleIMG setHidden:NO];
    }
    else
    {
         [cell.CancelBtn setHidden:YES];
        [cell.CancleIMG setHidden:YES];
    }
    //
    NSString *orderDate=[[[PendingOrderArr valueForKey:@"orderDate"] valueForKey:@"date"] objectAtIndex:indexPath.section];
    
    cell.OrderStatus_LBL.text=OrderStatus;
    cell.OderNumber_LBL.text=[[PendingOrderArr valueForKey:@"id"]objectAtIndex:indexPath.section];
    cell.OrderAmount_LBL.text=[NSString stringWithFormat:@"£%@",[[PendingOrderArr valueForKey:@"total"]objectAtIndex:indexPath.section]];
    cell.OderDate_LBL.text=orderDate;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetailView"];
    vcr.StatusMsg=OrderStatus;
    vcr.OrderHistryDetailDic=[[MainOrderHisrty valueForKey:@"orderHistory"] objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Completed_action:(id)sender
{
    
    
    //Disable
    self.LBL_pending.backgroundColor=[UIColor whiteColor];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_cancel.backgroundColor=[UIColor whiteColor];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
     OrderStatus=@"Completed";
    self.LBL_complete.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.CompleteBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
     [OrderHistyTableView reloadData];
    
}
- (IBAction)Pending_tabAction:(id)sender
{
    
    //Disable
    self.LBL_complete.backgroundColor=[UIColor whiteColor];
    [self.CompleteBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_cancel.backgroundColor=[UIColor whiteColor];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
     OrderStatus=@"Pending";
    self.LBL_pending.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
     [OrderHistyTableView reloadData];
    
}
- (IBAction)Cancel_TabAction:(id)sender
{
    
    //Disable
    self.LBL_complete.backgroundColor=[UIColor whiteColor];
    [self.CompleteBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_pending.backgroundColor=[UIColor whiteColor];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
     OrderStatus=@"Canceled";
    self.LBL_cancel.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
    [OrderHistyTableView reloadData];
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

- (IBAction)ToggleMenu:(id)sender
{
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}
@end
