//
//  MenuListWithImage.m
//  MirchMasala
//
//  Created by Mango SW on 10/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "MenuListWithImage.h"
#import "MirchMasala.pch"
#import "MenuImageCELL.h"
@interface MenuListWithImage ()
{
    NSMutableArray *ImageNameSection;
    NSMutableArray *TitleNameSection;
    NSMutableDictionary *subCategoryDic;
}
@end

@implementation MenuListWithImage
@synthesize IMGCollection,categoryName,CategoryId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    TitleNameSection=[[NSMutableArray alloc]initWithObjects:@"Chiken",@"Tandoori",@"Masala",@"Ringa",@"Bateta",@"Oroo rotala", nil];
    [IMGCollection registerClass:[MenuImageCELL class] forCellWithReuseIdentifier:@"cvCell"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [IMGCollection setCollectionViewLayout:flowLayout];
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self SUBCategoriesList];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    // Do any additional setup after loading the view.
}

-(void)SUBCategoriesList
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:@"3" forKey:@"CATEGORYID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"products" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         [KVNProgress dismiss];
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             subCategoryDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"products"];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}
- (IBAction)backBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Collection view layout things
#pragma mark COLLECTION VIEW

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    
    MenuImageCELL *cell = (MenuImageCELL *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    
   // cell.Title_Hight.constant=0;
    [cell.titleLabel setText:[TitleNameSection objectAtIndex:indexPath.row]];

    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    NSString *imagename=[ImageNameSection objectAtIndex:indexPath.row];
    UIImage *imge=[UIImage imageNamed:imagename];
    [cell.IconImageview setImage:imge];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(139, 139);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(166, 166);
    }
    else
    {
        mElementSize = CGSizeMake(185, 185);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return 12.0;
    }
    else if (IS_IPHONE_6)
    {
        return 10.0;
    }
    else if (IS_IPHONE_6P)
    {
        return 15.0;
    }
    return 15.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6P)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    
    return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
}


@end
