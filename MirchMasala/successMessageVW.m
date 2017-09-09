//
//  successMessageVW.m
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "successMessageVW.h"
#import "OrderHistryView.h"

@interface successMessageVW ()

@end

@implementation successMessageVW
@synthesize viewManageBtn,continueShoppingBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [viewManageBtn.layer setCornerRadius:20.0f];
    [viewManageBtn.layer setMasksToBounds:YES];
    
    [continueShoppingBtn.layer setCornerRadius:20.0f];
    [continueShoppingBtn.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view.
}
- (IBAction)ViewOrMange_Action:(id)sender
{
    OrderHistryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderHistryView"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)continueShopping_Action:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
