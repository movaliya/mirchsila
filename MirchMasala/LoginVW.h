//
//  LoginVW.h
//  MirchMasala
//
//  Created by Mango SW on 04/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVW : UIViewController
{
    NSString *ShowBack;
}
@property (strong, nonatomic) NSString *ShowBack;

@property (weak, nonatomic) IBOutlet UIView *EmailView;
@property (weak, nonatomic) IBOutlet UIView *PasswordView;
@property (weak, nonatomic) IBOutlet UIButton *SignInBtn;
- (IBAction)SignUp_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;

@property (strong, nonatomic) IBOutlet UITextField *Email_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Password_TXT;
@property (weak, nonatomic) IBOutlet UIImageView *EmailImageVW;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgeVW;
@property (strong, nonatomic) IBOutlet UIButton *BackBTN;
@end
