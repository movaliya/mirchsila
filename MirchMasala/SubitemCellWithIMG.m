//
//  SubitemCellWithIMG.m
//  MirchMasala
//
//  Created by kaushik on 10/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SubitemCellWithIMG.h"

@implementation SubitemCellWithIMG

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SubitemCellWithIMG" owner:self options:nil];
        
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
