//
//  CheckOut_AddressVIEW.m
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "CheckOut_AddressVIEW.h"
#import "CheckOut_OrderSummyVW.h"
#import "MYCartVW.h"


@interface CheckOut_AddressVIEW ()
{
    NSMutableDictionary *AddressRespose;
}
@end

@implementation CheckOut_AddressVIEW
@synthesize User_TXT,Email_TXT,Street_TXT,PostCode_TXT,Mobile_TXT,Country_TXT,user_View,Email_View,Street_View,PostCode_View,Mobile_View,Country_View,HouseNo_TXT,HouseName_TXT,HouseNo_View,HouseName_View,SaveNextBtn,CartTotalAmout;
@synthesize CartNotification_LBL;

- (void)viewDidLoad {
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
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
   
    
    // Corner and Color
    
    [user_View.layer setCornerRadius:25.0f];
    user_View.layer.borderWidth = 1.0f;
    [user_View.layer setMasksToBounds:YES];
    user_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Email_View.layer setCornerRadius:25.0f];
    Email_View.layer.borderWidth = 1.0f;
    [Email_View.layer setMasksToBounds:YES];
    Email_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Street_View.layer setCornerRadius:25.0f];
    Street_View.layer.borderWidth = 1.0f;
    [Street_View.layer setMasksToBounds:YES];
    Street_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [PostCode_View.layer setCornerRadius:25.0f];
    PostCode_View.layer.borderWidth = 1.0f;
    [PostCode_View.layer setMasksToBounds:YES];
    PostCode_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Mobile_View.layer setCornerRadius:25.0f];
    Mobile_View.layer.borderWidth = 1.0f;
    [Mobile_View.layer setMasksToBounds:YES];
    Mobile_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Country_View.layer setCornerRadius:25.0f];
    Country_View.layer.borderWidth = 1.0f;
    [Country_View.layer setMasksToBounds:YES];
    Country_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [HouseName_View.layer setCornerRadius:25.0f];
    HouseName_View.layer.borderWidth = 1.0f;
    [HouseName_View.layer setMasksToBounds:YES];
    HouseName_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [HouseNo_View.layer setCornerRadius:25.0f];
    HouseNo_View.layer.borderWidth = 1.0f;
    [HouseNo_View.layer setMasksToBounds:YES];
    HouseNo_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [SaveNextBtn.layer setCornerRadius:20.0f];
    [SaveNextBtn.layer setMasksToBounds:YES];
    
    //Disable a Usertext and EmailText
    User_TXT.enabled = NO;
    Email_TXT.enabled = NO;
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self GetUserProfileAddress];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}

-(void)GetUserProfileAddress
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
        
        [dictSub setObject:@"myProfile" forKey:@"METHOD"];
        
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
             
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 
                 NSMutableDictionary *myProfileDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"result"] objectForKey:@"myProfile"];
                 
                 User_TXT.text=[myProfileDic valueForKey:@"customerName"];
                 Email_TXT.text=[myProfileDic valueForKey:@"email"];
                 
                 if ([myProfileDic valueForKey:@"street"] != (id)[NSNull null])
                 {
                     Street_TXT.text=[myProfileDic valueForKey:@"street"];
                 }
                 if ([myProfileDic valueForKey:@"postCode"] != (id)[NSNull null])
                 {
                     PostCode_TXT.text=[myProfileDic valueForKey:@"postCode"];
                 }
                 if ([myProfileDic valueForKey:@"mobile"] != (id)[NSNull null])
                 {
                     Mobile_TXT.text=[myProfileDic valueForKey:@"mobile"];
                 }
                 if ([myProfileDic valueForKey:@"country"] != (id)[NSNull null])
                 {
                     Country_TXT.text=[myProfileDic valueForKey:@"country"];
                 }
                 if ([myProfileDic valueForKey:@"houseName"] != (id)[NSNull null])
                 {
                     HouseName_TXT.text=[myProfileDic valueForKey:@"houseName"];
                 }
                 if ([myProfileDic valueForKey:@"houseNo"] != (id)[NSNull null])
                 {
                     HouseNo_TXT.text=[myProfileDic valueForKey:@"houseNo"];
                 }
             }
             else
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Email and/or Password did not matched." delegate:nil];
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
- (IBAction)SaveNextBtn_Action:(id)sender
{
    if ([Street_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter street" delegate:nil];
    }
    else if ([PostCode_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter post code" delegate:nil];
    }
    else if ([Mobile_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter mobile number" delegate:nil];
    }
    else if ([Country_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter country" delegate:nil];
    }
    else if ([HouseName_TXT.text isEqualToString:@""] && [HouseNo_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter house name or house number" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            //[self checkMinimumAmout];
            [self UpdateUserProfileData];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
}
-(void)UpdateUserProfileData
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
        [dictInner setObject:Street_TXT.text forKey:@"STREET"];
        [dictInner setObject:PostCode_TXT.text forKey:@"POSTCODE"];
        [dictInner setObject:Country_TXT.text forKey:@"COUNTRY"];
        [dictInner setObject:Mobile_TXT.text forKey:@"MOBILE"];
        
        if (![HouseNo_TXT.text isEqualToString:@""]) {
            [dictInner setObject:HouseNo_TXT.text forKey:@"HOUSENO"];
        }
        if (![HouseName_TXT.text isEqualToString:@""]) {
            [dictInner setObject:HouseName_TXT.text forKey:@"HOUSENAME"];
        }
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"putitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"myProfile" forKey:@"METHOD"];
        
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
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
             
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 
                // NSString *SUCCESS=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"myProfile"] objectForKey:@"result"] objectForKey:@"myProfile"];
                 
                 //[AppDelegate showErrorMessageWithTitle:@"" message:SUCCESS delegate:nil];
                 [self checkMinimumAmout];
                 
             }
             else
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Your Address is not Update. Please Try After Some Time" delegate:nil];
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
-(void)checkMinimumAmout
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
        [dictInner setObject:Street_TXT.text forKey:@"STREET"];
        [dictInner setObject:PostCode_TXT.text forKey:@"POSTCODE"];
        [dictInner setObject:Country_TXT.text forKey:@"COUNTRY"];
        [dictInner setObject:Mobile_TXT.text forKey:@"MOBILE"];
        if (![HouseName_TXT.text isEqualToString:@""]) {
            [dictInner setObject:HouseName_TXT.text forKey:@"HOUSENAME"];
        }
        if (![HouseNo_TXT.text isEqualToString:@""]) {
            [dictInner setObject:HouseNo_TXT.text forKey:@"HOUSENO"];
        }
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"putitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"deliveryAddress" forKey:@"METHOD"];
        
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
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
              [KVNProgress dismiss] ;
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"deliveryAddress"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 
                AddressRespose=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"deliveryAddress"] objectForKey:@"result"] objectForKey:@"deliveryAddress"];
                 NSLog(@"AddressRespose==%@",AddressRespose);
                 
                 float minimumDeliveryAmount=[[AddressRespose valueForKey:@"minimumDeliveryAmount"] floatValue];
                 float grandtot=[CartTotalAmout floatValue];
                 if (minimumDeliveryAmount >grandtot)
                 {
                     // Cart value is lesser then minimum dilvry
                     NSString *alterMessage=[NSString stringWithFormat:@"You need to order minimum amount of £%.02f",minimumDeliveryAmount];
                     [AppDelegate showErrorMessageWithTitle:@"Minimum Requirement not meet." message:alterMessage delegate:nil];
                 }
                 else
                 {
                     // Push Next View
                     [KVNProgress dismiss] ;
                     [self performSelector:@selector(Pushtoordersummryview) withObject:nil afterDelay:0.1];
                 }
             }
             else
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Please try after some time." delegate:nil];
             }
             
            
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

-(void)Pushtoordersummryview
{
    [KVNProgress dismiss] ;
    CheckOut_OrderSummyVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckOut_OrderSummyVW"];
    vcr.deliveryCharge1=[AddressRespose valueForKey:@"deliveryCharge"];
    vcr.Comment2View=self.Comment1View;
    [self.navigationController pushViewController:vcr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)BackBtn_Action:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
