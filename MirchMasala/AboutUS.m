//
//  AboutUS.m
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "AboutUS.h"
#import "cartView.h"

@interface AboutUS ()

@end

@implementation AboutUS
@synthesize WebViewAbout;
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
         NSLog(@" not UserSaveData");
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0f;
    
    WebViewAbout.scrollView.showsHorizontalScrollIndicator = NO;
    WebViewAbout.scrollView.showsVerticalScrollIndicator = NO;
    
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    
    NSString* htmlString= @"<html><body><h4><center>Welcome to Mirch Masala Indian Takeaway</center></h4><br><span>Situated in Pensnett, the Mirch Masala Indian Takeaway offers mouth-watering Indian cuisine.</span></br><br>The Mirch Masala Indian Takeaway is renowned throughout the Pensnett and Dudley area for its divine style and presentation of traditional Indian cuisine, this is achieved by paying special attention to every fine detail and only using the very finest ingredients.</br><br>If you looking for the most exquisite Indian food in the Pensnett and Dudley area, then take a look and order from our easy to use on screen menu, you will see that we offer something for every member of your family. Our on-line menu is fully customisable, so why not give it a try! If your favourite meal is not on our menu just call 01384 78007 to ask us, and our chef will happily try and prepare it especially for you.</br><br>Our high quality Website is provided by tiffintom.com, please be sure to visit our website on a regular basis to see our latest menu updates.\n We deliver on all online orders to following postcodes DY1 DY2 DY3 DY5 DY4 DY6 DY8 B69 plus more also Pensenett Dudley and Brierley hill</br></body></html>";
    [WebViewAbout setBackgroundColor:[UIColor clearColor]];
    [WebViewAbout setOpaque:NO];
    [WebViewAbout loadHTMLString:htmlString baseURL:nil];
   
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
}- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
