//
//  GalleryFullView.h
//  MirchMasala
//
//  Created by Mango SW on 26/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface GalleryFullView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableArray *ImageNameSection;
    int SelectIndex;
}

@property (strong, nonatomic) NSMutableArray *ImagArr;
@property (strong, nonatomic) NSString *SelectedImage;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet UIScrollView *ImageScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW;

@end
