//
//  SubitemCell.m
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SubitemCell.h"

@implementation SubitemCell
@synthesize optionBtn,ProductName;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    optionBtn.layer.cornerRadius=5;
    optionBtn.layer.masksToBounds=YES;
    optionBtn.layer.borderColor=[[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0] CGColor];
    optionBtn.layer.borderWidth=1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
