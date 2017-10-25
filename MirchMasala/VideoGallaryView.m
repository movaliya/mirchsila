//
//  VideoGallaryView.m
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "VideoGallaryView.h"
#import "MirchMasala.pch"
#import "AVKit/AVKit.h"
#import "AVFoundation/AVFoundation.h"
#import "VideoCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoGallaryView ()
{
    NSMutableArray *ImageNameSection;
    NSMutableArray *VideoArr;
}
@end

@implementation VideoGallaryView

@synthesize VideoTBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    
    UINib *nib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    VideoCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    VideoTBL.rowHeight = cell.frame.size.height;
    
    [VideoTBL registerNib:nib forCellReuseIdentifier:@"VideoCell"];
    
  //  [self VideoGalleryService];
    
    Thubnil=[self generateThumbImage:@"https://www.youtube.com/watch?v=QoE7HTHDaRk"];
    [VideoTBL reloadData];
    /*
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://youtu.be/wWUzXFG_F4g"]];
    
    AVPlayerViewController * _moviePlayer1 = [[AVPlayerViewController alloc] init];
    _moviePlayer1.player = [AVPlayer playerWithURL:url];
    
    [self presentViewController:_moviePlayer1 animated:YES completion:^{
        [_moviePlayer1.player play];
    }];*/
    
}
-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 1000;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

-(void)setImage:(NSString*)urlResponse
{
    NSString *youtubeUrl = [NSString stringWithFormat:@"%@",[self parseVideoHTMLUrl: urlResponse]];
    
    NSString *videoThumbUrl = [self getYoutubeVideoThumbnail: youtubeUrl];
    
    NSURL* videoURL =[NSURL URLWithString:videoThumbUrl];
    NSLog(@"");
    
   // [btn_photo sd_setImageWithURL:videoURL forState:UIControlStateNormal];
}

-(NSString*)getYoutubeVideoThumbnail:(NSString*)youTubeUrl
{
    NSString* video_id = @"";
    
    if (youTubeUrl.length > 0)
    {
        NSError *error = NULL;
        NSRegularExpression *regex =
        [NSRegularExpression regularExpressionWithPattern:@"(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*"
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:youTubeUrl
                                                        options:0
                                                          range:NSMakeRange(0, [youTubeUrl length])];
        if (match)
        {
            NSRange videoIDRange = [match rangeAtIndex:0];
            video_id = [youTubeUrl substringWithRange:videoIDRange];
            
            NSLog(@"%@",video_id);
        }
    }
    
    NSString* thumbImageUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/default.jpg",video_id];
    
    return thumbImageUrl;
}

-(NSString *)parseVideoHTMLUrl:(NSString *)videoUrl
{
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@";//(.+?)\\&quot;"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:videoUrl options:0 range:NSMakeRange(0, videoUrl.length)];
    
    NSString *url = [videoUrl substringWithRange:[textCheckingResult rangeAtIndex:1]];
    
    return url;
}

-(void)VideoGalleryService
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"videoGallery" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"videoGallery"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             VideoArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"videoGallery"] objectForKey:@"result"] objectForKey:@"videoGallery"] mutableCopy];
             [self setImage:@"https://www.youtube.com/watch?v=b_J7ByLJw5A"];
             [VideoTBL reloadData];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ImageNameSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoCell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    cell.Thumbimg.image=Thubnil;
    //cell.Thumbimg.image=[UIImage imageNamed:[ImageNameSection objectAtIndex:indexPath.section]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
