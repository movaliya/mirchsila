//
//  ReservationSubVW.m
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ReservationSubVW.h"

@interface ReservationSubVW ()

@end

@implementation ReservationSubVW

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backView.layer.masksToBounds = NO;
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowRadius = 1.0;
    self.backView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    self.backView.layer.shadowOpacity = 0.5;
    // Do any additional setup after loading the view.
}
- (IBAction)SubmitBtn_Action:(id)sender {
}
- (IBAction)backBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
