//
//  AboutUS.m
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "AboutUS.h"
#import "cartView.h"
#import "AboutUsCELL.h"
#import "MirchMasala.pch"

@interface AboutUS ()

@end

@implementation AboutUS
@synthesize WebViewAbout;
@synthesize CartNotification_LBL;
@synthesize TableVW;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
         NSLog(@" not UserSaveData");
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0f;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    AboutDataArr=[[NSMutableArray alloc]init];
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"About1",@"About2",@"About3",@"About4",@"About5",@"About6", nil];
    TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Application Name",@"Build Version",@"Email",@"Copyright",@"Share",@"Rate", nil];
    
    DescriptionNameSection=[[NSMutableArray alloc]initWithObjects:@"Silsila Restaurant",@"Version 1.0",@"info@yourdomainname.com",@"Copyright @ 2017 Nibs Solution. All Rights reserved",@"Share to your friends",@"Give your rate & feedback", nil];
    
    UINib *nib = [UINib nibWithNibName:@"AboutUsCELL" bundle:nil];
    AboutUsCELL *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TableVW.rowHeight = cell.frame.size.height;
    [TableVW registerNib:nib forCellReuseIdentifier:@"AboutUsCELL"];
    
    TableVW.tableHeaderView = nil;
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallAboutService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];

}

-(void)CallAboutService
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"appButtons" forKey:@"METHOD"];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NSMutableArray *TempSocialDataArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"result"] objectForKey:@"appButtons"] mutableCopy];
             
             for (int ii=0; ii<TempSocialDataArr.count; ii++)
             {
                 NSString *CheckButtontype=[[TempSocialDataArr valueForKey:@"button_type"] objectAtIndex:ii];
                 if ([CheckButtontype isEqualToString:@"Link"]||[CheckButtontype isEqualToString:@"Text"])
                 {
                     [AboutDataArr addObject:[TempSocialDataArr objectAtIndex:ii]];
                 }
             }
             
             
             [TableVW reloadData];
             
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AboutDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AboutUsCELL";
    AboutUsCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    cell.TitleLBL.text=[[AboutDataArr valueForKey:@"title"] objectAtIndex:indexPath.section];
    NSString *Urlstr=[[AboutDataArr valueForKey:@"image_path"] objectAtIndex:indexPath.section];
    [cell.ImageVW sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.ImageVW setShowActivityIndicatorView:YES];
   
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSString *Urlstr=[[AboutDataArr valueForKey:@"content"] objectAtIndex:indexPath.section];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Urlstr]];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        return 75;
    }
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
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

- (IBAction)Menu_Toggle:(id)sender {
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
