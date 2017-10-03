//
//  GalleryFullView.m
//  MirchMasala
//
//  Created by Mango SW on 26/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "GalleryFullView.h"

@interface GalleryFullView ()

@end

@implementation GalleryFullView
@synthesize ImageScrollView,imageVW;
@synthesize ImagArr,SelectedImage;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    
    
    for (int i = 0; i < ImagArr.count; i++)
    {
        CGRect frame;
        frame.origin.x = ImageScrollView.frame.size.width * i;
        frame.origin.y = 0;
        
        //frame.origin.x = 0;
       // frame.origin.y = ImageScrollView.frame.size.height * i;
        
        frame.size = ImageScrollView.frame.size;
       UIImageView *newPageView = [[UIImageView alloc] init];
        NSString *Urlstr=[[ImagArr valueForKey:@"image_path"] objectAtIndex:i];
        [newPageView sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [newPageView setShowActivityIndicatorView:YES];
        
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [ImageScrollView addSubview:newPageView];
    }
    ImageScrollView.contentSize = CGSizeMake(ImageScrollView.frame.size.width * ImagArr.count , ImageScrollView.frame.size.height);
    
    //ImageScrollView.contentSize = CGSizeMake(ImageScrollView.frame.size.width , ImageScrollView.frame.size.height* ImageNameSection.count);
    
    int selectindex=[SelectedImage integerValue];
    [ImageScrollView setContentOffset:CGPointMake(ImageScrollView.frame.size.width*selectindex, 0.0f) animated:YES];

   
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (IBAction)BackBtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
