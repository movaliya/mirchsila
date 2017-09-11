//
//  SideMenuCollectioVW.m
//  MirchMasala
//
//  Created by Mango SW on 11/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SideMenuCollectioVW.h"

@implementation SideMenuCollectioVW

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SideMenuCollectioVW" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
