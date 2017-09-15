//
//  SocialView.h
//  MirchMasala
//
//  Created by kaushik on 13/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialView : UIViewController
{
    NSMutableArray *SocialDataArr;
}
- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *MainTBL;
@end
