//
//  ProfileView.m
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ProfileView.h"
#import "MYCartVW.h"

@interface ProfileView ()
{
    UIDatePicker *DOBdatePicker,*ADdatePicker;
}
@end

@implementation ProfileView
@synthesize User_TXT,Email_TXT,Street_TXT,PostCode_TXT,Mobile_TXT,Country_TXT,HouseName_TXT,HoueNoTXT,Town_TXT,State_TXT,DOB_TXT,AD_TXT,user_View,Email_View,Street_View,PostCode_View,Mobile_View,Country_View,HouseNoView,HouseNameView,TownView,StateView,DOBView,ADView,update_Btn;

@synthesize CartNotification_LBL;


-(void)SetviewCorner
{
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
    
    [HouseNoView.layer setCornerRadius:25.0f];
    HouseNoView.layer.borderWidth = 1.0f;
    [HouseNoView.layer setMasksToBounds:YES];
    HouseNoView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [HouseNameView.layer setCornerRadius:25.0f];
    HouseNameView.layer.borderWidth = 1.0f;
    [HouseNameView.layer setMasksToBounds:YES];
    HouseNameView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [StateView.layer setCornerRadius:25.0f];
    StateView.layer.borderWidth = 1.0f;
    [StateView.layer setMasksToBounds:YES];
    StateView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [TownView.layer setCornerRadius:25.0f];
    TownView.layer.borderWidth = 1.0f;
    [TownView.layer setMasksToBounds:YES];
    TownView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [DOBView.layer setCornerRadius:25.0f];
    DOBView.layer.borderWidth = 1.0f;
    [DOBView.layer setMasksToBounds:YES];
    DOBView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [ADView.layer setCornerRadius:25.0f];
    ADView.layer.borderWidth = 1.0f;
    [ADView.layer setMasksToBounds:YES];
    ADView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [update_Btn.layer setCornerRadius:20.0f];
    [update_Btn.layer setMasksToBounds:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    // Corner and Color
    [self SetviewCorner];
    
    //Disable a Usertext and EmailText
    User_TXT.enabled = NO;
    Email_TXT.enabled = NO;
    //AD_TXT.enabled = NO;
    
    
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
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
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
         [self GetUserProfileData];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    //Set DOB DatePicker
    DOBdatePicker = [[UIDatePicker alloc]init];
    [DOBdatePicker setDate:[NSDate date]]; //this returns today's date
    
    
    NSString *maxDateString = @"01-Jan-2000";
    NSString *minDateString = @"01-Jan-1950";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM/dd/yyyy";
    NSDate *theMaximumDate = [dateFormatter dateFromString: maxDateString];
    NSDate *theMinimumDate = [dateFormatter dateFromString: minDateString];
    
    // repeat the same logic for theMinimumDate if needed
    
    [DOBdatePicker setMaximumDate:theMaximumDate]; //the min age restriction
    [DOBdatePicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
    
    // set the mode
    [DOBdatePicker setDatePickerMode:UIDatePickerModeDate];
    [DOBdatePicker addTarget:self action:@selector(updateDOBTextField:) forControlEvents:UIControlEventValueChanged];
    [DOB_TXT setInputView:DOBdatePicker];
    
    //Set AD DatePicker
    ADdatePicker = [[UIDatePicker alloc]init];
    [ADdatePicker setDate:[NSDate date]]; //this returns today's date
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM/dd/yyyy";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    NSString *maxDateStringforad = string;
   // NSString *minDateString = @"01-Jan-1950";
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSDate *theMaximumDateforad = [dateFormatter dateFromString: maxDateStringforad];
    //NSDate *theMinimumDate = [dateFormatter dateFromString: minDateString];
    
    // repeat the same logic for theMinimumDate if needed
    
    [ADdatePicker setMaximumDate:theMaximumDateforad]; //the min age restriction
   // [ADdatePicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
    
    // set the mode
    [ADdatePicker setDatePickerMode:UIDatePickerModeDate];
    [ADdatePicker addTarget:self action:@selector(updateADTextField:) forControlEvents:UIControlEventValueChanged];
    [AD_TXT setInputView:ADdatePicker];
}

-(void)Removekeyboadr
{
    [User_TXT resignFirstResponder];
    [Email_TXT resignFirstResponder];
    [Street_TXT resignFirstResponder];
    [PostCode_View resignFirstResponder];
    [Mobile_TXT resignFirstResponder];
    [HoueNoTXT resignFirstResponder];
    [HouseName_TXT resignFirstResponder];
    [State_TXT resignFirstResponder];
    [AD_TXT resignFirstResponder];
    [Town_TXT resignFirstResponder];
    [DOBdatePicker resignFirstResponder];
}

-(void)updateDOBTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)DOB_TXT.inputView;
    DOB_TXT.text = [self formatDate:picker.date];
}

-(void)updateADTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)AD_TXT.inputView;
    AD_TXT.text = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void)GetUserProfileData
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
             NSLog(@"responseObject==%@",responseObject);
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
                 if ([myProfileDic valueForKey:@"houseNo"] != (id)[NSNull null])
                 {
                     HoueNoTXT.text=[myProfileDic valueForKey:@"houseNo"];
                 }
                 if ([myProfileDic valueForKey:@"houseName"] != (id)[NSNull null])
                 {
                     HouseName_TXT.text=[myProfileDic valueForKey:@"houseName"];
                 }
                 if ([myProfileDic valueForKey:@"town"] != (id)[NSNull null])
                 {
                     Town_TXT.text=[myProfileDic valueForKey:@"town"];
                 }
                 if ([myProfileDic valueForKey:@"state"] != (id)[NSNull null])
                 {
                     State_TXT.text=[myProfileDic valueForKey:@"state"];
                 }
                 if ([myProfileDic valueForKey:@"dateOfBirth"] != (id)[NSNull null])
                 {
                     DOB_TXT.text=[myProfileDic valueForKey:@"dateOfBirth"];
                 }
                 if ([myProfileDic valueForKey:@"anniverseryDate"] != (id)[NSNull null])
                 {
                     AD_TXT.text=[myProfileDic valueForKey:@"anniverseryDate"];
                 }
                
             }
             else
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Server Error." delegate:nil];
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
        Street_TXT.enabled = NO;
        PostCode_TXT.enabled = NO;
        Mobile_TXT.enabled = NO;
        Country_TXT.enabled = NO;
        update_Btn.enabled=NO;
        [AppDelegate showErrorMessageWithTitle:@"" message:@"You are not Login." delegate:nil];
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
        
        if (![HoueNoTXT.text isEqualToString:@""]) {
             [dictInner setObject:HoueNoTXT.text forKey:@"HOUSENO"];
        }
        if (![HouseName_TXT.text isEqualToString:@""]) {
             [dictInner setObject:HouseName_TXT.text forKey:@"HOUSENAME"];
        }
        if (![Town_TXT.text isEqualToString:@""]) {
             [dictInner setObject:Town_TXT.text forKey:@"TOWN"];
        }
        if (![State_TXT.text isEqualToString:@""]) {
             [dictInner setObject:State_TXT.text forKey:@"STATE"];
        }
        if (![DOB_TXT.text isEqualToString:@""]) {
             [dictInner setObject:DOB_TXT.text forKey:@"DATEOFBIRTH"];
        }
        if (![AD_TXT.text isEqualToString:@""]) {
             [dictInner setObject:AD_TXT.text forKey:@"ANNIVERSARYDATE"];
            NSLog(@"anniveryDate=%@",AD_TXT.text);
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
                 
                 NSString *SUCCESS=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"myProfile"] objectForKey:@"result"] objectForKey:@"myProfile"];
                 
                  [AppDelegate showErrorMessageWithTitle:@"" message:SUCCESS delegate:nil];
                
                 
             }
             else
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Your Profile Data is not Update. Please Try After Some Time" delegate:nil];
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

- (IBAction)Menu_Toggle:(id)sender
{
    [self Removekeyboadr];
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Update_Action:(id)sender
{
    [self Removekeyboadr];
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
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self UpdateUserProfileData];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
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


@end
