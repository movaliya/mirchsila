//
//  MessageTblCell.m
//  MirchMasala
//
//  Created by jignesh solanki on 01/02/2018.
//  Copyright © 2018 jkinfoway. All rights reserved.
//

#import "MessageTblCell.h"

@implementation MessageTblCell
@synthesize MessageIMG;

- (void)awakeFromNib {
    [super awakeFromNib];
    MessageIMG.layer.cornerRadius=30.0f;
    MessageIMG.layer.masksToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
