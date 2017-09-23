//
//  SubitemCellWithIMG.h
//  MirchMasala
//
//  Created by kaushik on 10/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubitemCellWithIMG : UICollectionViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *ItemIMG;
@property (strong, nonatomic) IBOutlet UILabel *ItemTitel_LBL;
@property (strong, nonatomic) IBOutlet UILabel *ItemDesc_LBL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ViewHight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Title_TOP;

@end
