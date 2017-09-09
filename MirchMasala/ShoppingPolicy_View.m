//
//  ShoppingPolicy_View.m
//  MirchMasala
//
//  Created by Mango SW on 17/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ShoppingPolicy_View.h"
#import "cartView.h"

@interface ShoppingPolicy_View ()

@end

@implementation ShoppingPolicy_View
@synthesize NotificationCartLBL,MyWebView;
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
        [NotificationCartLBL setHidden:NO];
        NotificationCartLBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
    }
    else
    {
        [NotificationCartLBL setHidden:YES];
    }

    
    NotificationCartLBL.layer.masksToBounds = YES;
    NotificationCartLBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    MyWebView.scrollView.showsHorizontalScrollIndicator = NO;
    MyWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    [MyWebView loadHTMLString:@"about:blank" baseURL:nil];
   
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSString * myURLString = @"https://parivahan.gov.in/rcdlstatus/?pur_cd=102";
        NSURL * url = [[NSURL alloc] initWithString:myURLString];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        
        //assuming, the property webView ist the UIWebView you want to change
        [MyWebView loadRequest:request];
        
       // [MyWebView stringByEvaluatingJavaScriptFromString:@"document.tf_reg_no1.text.value='ANdrew';"];
       

    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
   
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
       [KVNProgress show] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [KVNProgress dismiss] ;
   
    
   // [MyWebView stringByEvaluatingJavaScriptFromString:@"('div[ui-view=\"navbar\"]').remove();"];

    [MyWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('header-logo-section').remove();"];
    
    [MyWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('home').remove();"];

   
    
    NSString *evaluate = [NSString stringWithFormat:@"document.form_rcdl.value='%@';", @"New title"];
    [MyWebView stringByEvaluatingJavaScriptFromString:evaluate];
    
    [MyWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('form_rcdl:tf_reg_no1').value='GJ32C';"];
    
    [MyWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('form_rcdl:tf_reg_no2').value='8685';"];
    
    [MyWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('form_rcdl:tf_Mobile').value='9228373027';"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [KVNProgress dismiss] ;
}
- (IBAction)TopBarCart_action:(id)sender
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

- (IBAction)ToggleMenu_action:(id)sender {
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
