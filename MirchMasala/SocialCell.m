//
//  SocialCell.m
//  MirchMasala
//
//  Created by kaushik on 13/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SocialCell.h"

@implementation SocialCell
@synthesize BackView;
- (void)awakeFromNib
{
    [super awakeFromNib];
    BackView.layer.borderColor= [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.borderWidth=0.5;
    BackView.layer.cornerRadius=3;
    BackView.layer.masksToBounds = NO;
    BackView.layer.shadowOffset = CGSizeMake(0, 1);
    BackView.layer.shadowRadius = 0.2;
    BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.shadowOpacity = 0.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
