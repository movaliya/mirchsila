//
//  LoginVW.m
//  MirchMasala
//
//  Created by Mango SW on 04/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "LoginVW.h"
#import <QuartzCore/QuartzCore.h>
#import "SignUpView.h"
#import "ForgotPasswordView.h"
#import "AppDelegate.h"
#import "MirchMasala.pch"
#import "HomeView.h"
#import "AppDelegate.h"

@interface LoginVW ()
@property AppDelegate *appDelegate;

@end

@implementation LoginVW
@synthesize emailTxt,passwordTxt;
@synthesize ShowBack,BackBTN;

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    BackBTN.hidden=NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    [_EmailView.layer setCornerRadius:25.0f];
    _EmailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _EmailView.layer.borderWidth = 1.0f;
    [_EmailView.layer setMasksToBounds:YES];
    _EmailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    
    [_PasswordView.layer setCornerRadius:25.0f];
    _PasswordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _PasswordView.layer.borderWidth = 1.0f;
    [_PasswordView.layer setMasksToBounds:YES];
    _passwordImgeVW.image=[UIImage imageNamed:@"DisablePassword"];
    
    [_SignInBtn.layer setCornerRadius:20.0f];
    [_SignInBtn.layer setMasksToBounds:YES];
    
    
    // Temp Login
    //emailTxt.text=@"jigneshbs@outlook.com";
    //passwordTxt.text=@"12345";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)SignIn_action:(id)sender
{
    
    if ([emailTxt.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:emailTxt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            if ([passwordTxt.text isEqualToString:@""])
            {
                [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self CallForloging:emailTxt.text Password:passwordTxt.text];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            }
        }
    }
}

-(void)CallForloging :(NSString *)EmailStr Password:(NSString *)PasswordStr
{
    
     [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:EmailStr forKey:@"EMAIL"];
    
    [dictInner setObject:PasswordStr forKey:@"PASSWORD"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"authenticate" forKey:@"METHOD"];
    
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
        [KVNProgress dismissWithCompletion:^{
            NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"SUCCESS"];
            if ([SUCCESS boolValue] ==YES)
            {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"LoginUserDic"];
                
                HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
                [self.navigationController pushViewController:vcr animated:YES];
                emailTxt.text=@"";
                passwordTxt.text=@"";
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Login successful" delegate:nil];
            }
            else
            {
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Email and/or Password did not matched." delegate:nil];
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

- (IBAction)SignUp_action:(id)sender
{
    SignUpView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)ForgotPass_action:(id)sender
{
    emailTxt.text=@"";
    passwordTxt.text=@"";
    ForgotPasswordView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgotPasswordView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SignUp_Click:(id)sender
{
    emailTxt.text=@"";
    passwordTxt.text=@"";
    SignUpView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpView"];
    [self.navigationController pushViewController:vcr animated:YES];
   
}
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == emailTxt)
    {
        emailTxt.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
        _EmailView.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0].CGColor;
        _EmailImageVW.image=[UIImage imageNamed:@"Emailicon"];
    }
    else if (textField == passwordTxt)
    {
        passwordTxt.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
        _PasswordView.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0].CGColor;
        _passwordImgeVW.image=[UIImage imageNamed:@"PasswordIcon"];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    if (textField == emailTxt)
    {
        emailTxt.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _EmailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
         _EmailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    }
    else if (textField == passwordTxt)
    {
        passwordTxt.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _PasswordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _passwordImgeVW.image=[UIImage imageNamed:@"DisablePassword"];
    }
    return YES;
}
@end
