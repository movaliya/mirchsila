//
//  NewsVW.m
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "NewsVW.h"
#import "NewsCell.h"
#import "NewsFullView.h"
#import "MirchMasala.pch"
@interface NewsVW ()
{
    NSMutableArray *ImageNameSection;
}
@end

@implementation NewsVW
@synthesize News_TBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];

    
    static NSString *CellIdentifier = @"NewsCell";
    UINib *nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
    [News_TBL registerNib:nib forCellReuseIdentifier:CellIdentifier];
    News_TBL.estimatedRowHeight = 220;
    News_TBL.rowHeight = UITableViewAutomaticDimension;
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallNewsService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
-(void)CallNewsService
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
   
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"news" forKey:@"METHOD"];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"news"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NewsDataArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"news"] objectForKey:@"result"] objectForKey:@"news"] mutableCopy];
             
             [News_TBL reloadData];
             
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
- (IBAction)backBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NewsDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    NSString *Urlstr=[[NewsDataArr valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    [cell.NewsIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.NewsIMG setShowActivityIndicatorView:YES];
    
    cell.NewsTitle_LBL.text=[[NewsDataArr valueForKey:@"title"] objectAtIndex:indexPath.row];
    cell.Date_LBL.text=[[NewsDataArr valueForKey:@"news_date"] objectAtIndex:indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFullView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsFullView"];
    vcr.NewsSelectArr=[NewsDataArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcr animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0f;
}

@end
