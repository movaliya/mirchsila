//
//  ContactUsView.h
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface ContactUsView : UIViewController<CCKFNavDrawerDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet UITextField *UserName_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Email_TXT;
@property (weak, nonatomic) IBOutlet UITextView *Message_TXT;
@property (weak, nonatomic) IBOutlet UIImageView *User_Icon;
@property (weak, nonatomic) IBOutlet UIImageView *Email_Icon;
@property (weak, nonatomic) IBOutlet UIImageView *Message_Icon;
@property (weak, nonatomic) IBOutlet UIView *user_View;
@property (weak, nonatomic) IBOutlet UIView *email_View;
@property (weak, nonatomic) IBOutlet UIView *Message_View;
@property (weak, nonatomic) IBOutlet UIButton *Submit_Btn;

@end
