//
//  ForgotPasswordView.m
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ForgotPasswordView.h"
#import "AppDelegate.h"
#import "MirchMasala.pch"


@interface ForgotPasswordView ()
@property AppDelegate *appDelegate;

@end

@implementation ForgotPasswordView
@synthesize EmailTxt;

- (BOOL)prefersStatusBarHidden {
     return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [_EmailView.layer setCornerRadius:25.0f];
    _EmailView.layer.borderWidth = 1.0f;
    _EmailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _emailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    [_EmailView.layer setMasksToBounds:YES];
    
    [_submitBtn.layer setCornerRadius:20.0f];
    [_submitBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SumbitBtn_action:(id)sender
{
    if ([EmailTxt.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:EmailTxt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self callFroResetPassword];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

-(void)callFroResetPassword
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:EmailTxt.text forKey:@"EMAIL"];
    
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"forgotPassword" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    
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
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"forgotPassword"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NSString *SUCCESS=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"forgotPassword"] objectForKey:@"result"]objectForKey:@"forgotPassword"] objectForKey:@"msg"];
             EmailTxt.text=@"";
            [self.navigationController popViewControllerAnimated:YES];
             [AppDelegate showErrorMessageWithTitle:@"Successfully" message:SUCCESS delegate:nil];
         }
         else
         {
             NSString *ERROR=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"forgotPassword"] objectForKey:@"ERROR"]objectForKey:@"DESCRIPTION"];
             
             [AppDelegate showErrorMessageWithTitle:@"" message:ERROR delegate:nil];
         }
         
         [KVNProgress dismiss] ;
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

- (IBAction)backBtn_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == EmailTxt)
    {
        EmailTxt.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        _EmailView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        _emailImageVW.image=[UIImage imageNamed:@"Emailicon"];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldEndEditing");
    if (textField == EmailTxt)
    {
        EmailTxt.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _EmailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _emailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    }
    return YES;
}

@end
