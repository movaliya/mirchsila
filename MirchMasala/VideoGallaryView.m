//
//  VideoGallaryView.m
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "VideoGallaryView.h"
#import "CVCell.h"
#import "MirchMasala.pch"

@interface VideoGallaryView ()
{
    NSMutableArray *ImageNameSection;
}
@end

@implementation VideoGallaryView
@synthesize GalleryCollection;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    [GalleryCollection registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [GalleryCollection setCollectionViewLayout:flowLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    cell.layer.masksToBounds = NO;
//    cell.layer.shadowOffset = CGSizeMake(0, 1);
//    cell.layer.shadowRadius = 1.0;
//    cell.layer.shadowColor = [UIColor blackColor].CGColor;
//    cell.layer.shadowOpacity = 0.5;
    
    cell.Title_Hight.constant=0;
    
    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    NSString *imagename=[ImageNameSection objectAtIndex:indexPath.row];
    UIImage *imge=[UIImage imageNamed:imagename];
    [cell.IconImageview setImage:imge];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark Collection view layout things

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(158.8f, 158.8f);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(186.5f, 186.5f);
    }
    else
    {
        mElementSize = CGSizeMake(206, 206);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0); // top, left, bottom, right
}

@end
