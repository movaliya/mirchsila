//
//  ReservationVW.m
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ReservationVW.h"
#import "ReservationSubVW.h"
@interface ReservationVW ()

@end

@implementation ReservationVW

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BackView.layer.masksToBounds = NO;
    self.BackView.layer.shadowOffset = CGSizeMake(0, 1);
    self.BackView.layer.shadowRadius = 1.0;
    self.BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    self.BackView.layer.shadowOpacity = 0.5;
    
    
     NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)SubmitBtn_Action:(id)sender
{
    ReservationSubVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationSubVW"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn_Action:(id)sender
{
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
