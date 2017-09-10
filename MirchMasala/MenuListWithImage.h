//
//  MenuListWithImage.h
//  MirchMasala
//
//  Created by Mango SW on 10/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuListWithImage : UIViewController
{
    NSString *CategoryId,*categoryName;
}
@property (strong, nonatomic) NSString *CategoryId;
@property (strong, nonatomic) NSString *categoryName;

@property (strong, nonatomic) IBOutlet UICollectionView *IMGCollection;

@property (strong, nonatomic) IBOutlet UILabel *HeaderTitle_LBL;
@end
