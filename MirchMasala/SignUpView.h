//
//  SignUpView.h
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpView : UIViewController
@property (weak, nonatomic) IBOutlet UIView *UsernamView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *confrimPasswordView;
@property (weak, nonatomic) IBOutlet UIButton *SignUpBtn;

@property (strong, nonatomic) IBOutlet UITextField *Username_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Email_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Password_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Confir_TXT;
@property (weak, nonatomic) IBOutlet UIImageView *UserImageVW;
@property (weak, nonatomic) IBOutlet UIImageView *EmailImageVW;
@property (weak, nonatomic) IBOutlet UIImageView *PasswordImageVw;
@property (weak, nonatomic) IBOutlet UIImageView *ConfrimPassImageVW;

- (IBAction)Signin_Click:(id)sender;

- (IBAction)Back_click:(id)sender;
@end
