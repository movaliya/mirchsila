//
//  SignUpView.m
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SignUpView.h"
#import "LoginVW.h"
#import "MirchMasala.pch"
#import "AFNetworking/AFNetworking.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "HomeView.h"

@interface SignUpView ()
@property AppDelegate *appDelegate;

@end

@implementation SignUpView
@synthesize Username_TXT,Email_TXT,Password_TXT,Confir_TXT;

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
  
    
    [super viewDidLoad];
    
    [_UsernamView.layer setCornerRadius:25.0f];
    _UsernamView.layer.borderWidth = 1.0f;
    [_UsernamView.layer setMasksToBounds:YES];
    
    [_emailView.layer setCornerRadius:25.0f];
    _emailView.layer.borderWidth = 1.0f;
    [_emailView.layer setMasksToBounds:YES];
    
    [_passwordView.layer setCornerRadius:25.0f];
    _passwordView.layer.borderWidth = 1.0f;
    [_passwordView.layer setMasksToBounds:YES];
    
    [_confrimPasswordView.layer setCornerRadius:25.0f];
    _confrimPasswordView.layer.borderWidth = 1.0f;
    [_confrimPasswordView.layer setMasksToBounds:YES];
    
    //Disable Color and Image
    _emailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _EmailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    _passwordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _PasswordImageVw.image=[UIImage imageNamed:@"DisablePassword"];
    _UsernamView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _UserImageVW.image=[UIImage imageNamed:@"DisableUser"];
    _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _ConfrimPassImageVW.image=[UIImage imageNamed:@"DisablePassword"];
    
    [_SignUpBtn.layer setCornerRadius:20.0f];
    [_SignUpBtn.layer setMasksToBounds:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SignUp_action:(id)sender

{
    if ([Username_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([Email_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([Password_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
    }
    else if ([Confir_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter confrim password" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![Confir_TXT.text isEqualToString:Password_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Confrim password do not match." delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                NSString *firstName;
                NSString *lastName;
                NSArray *myArray = [Username_TXT.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
                if (myArray.count>1) {
                    firstName=[myArray objectAtIndex:0];
                    lastName=[myArray objectAtIndex:1];
                }
                else
                {
                    firstName=[myArray objectAtIndex:0];
                    lastName=@"";
                }
                
                [self Callforregister:Email_TXT.text Pass:Password_TXT.text Fname:firstName Lname:lastName];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

-(void)Callforregister :(NSString *)EmailStr Pass:(NSString *)PasswordStr Fname:(NSString *)FnameStr Lname:(NSString *)LNameStr
{
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:EmailStr forKey:@"EMAIL"];
    [dictInner setObject:PasswordStr forKey:@"PASSWORD"];
    [dictInner setObject:FnameStr forKey:@"FIRSTNAME"];
    [dictInner setObject:LNameStr forKey:@"LASTNAME"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"postitem" forKey:@"MODULE"];
    [dictSub setObject:@"registration" forKey:@"METHOD"];
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
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"registration"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
             [self.navigationController pushViewController:vcr animated:YES];
              [AppDelegate showErrorMessageWithTitle:@"" message:@"Registration successful" delegate:nil];
         }
         else
         {
              NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"registration"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
             
             [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
         }
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"Fail");
         
     }];
}

- (IBAction)Signin_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == Email_TXT)
    {
        Email_TXT.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
        _emailView.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0].CGColor;
        _EmailImageVW.image=[UIImage imageNamed:@"Emailicon"];
    }
    else if (textField == Password_TXT)
    {
        Password_TXT.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
        _passwordView.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0].CGColor;
        _PasswordImageVw.image=[UIImage imageNamed:@"PasswordIcon"];
    }
    else if (textField == Username_TXT)
    {
        Username_TXT.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
        _UsernamView.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0].CGColor;
        _UserImageVW.image=[UIImage imageNamed:@"UserIcon"];
    }
    else if (textField == Confir_TXT)
    {
        Confir_TXT.textColor=[UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0];
        _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(207/255.0) green:(197/255.0) blue:(144/255.0) alpha:1.0].CGColor;
        _ConfrimPassImageVW.image=[UIImage imageNamed:@"PasswordIcon"];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    
    
    
    if (textField == Email_TXT)
    {
        Email_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _emailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _EmailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    }
    else if (textField == Password_TXT)
    {
        Password_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _passwordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _PasswordImageVw.image=[UIImage imageNamed:@"DisablePassword"];
    }
    else if (textField == Username_TXT)
    {
        Username_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _UsernamView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _UserImageVW.image=[UIImage imageNamed:@"DisableUser"];
    }
    else if (textField == Confir_TXT)
    {
        Confir_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _ConfrimPassImageVW.image=[UIImage imageNamed:@"DisablePassword"];
    }
    return YES;
}
@end
