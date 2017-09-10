//
//  MenuImageCELL.h
//  MirchMasala
//
//  Created by Mango SW on 10/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuImageCELL : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *IconImageview;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Title_Hight;
@end
