//
//  SocialView.m
//  MirchMasala
//
//  Created by kaushik on 13/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SocialView.h"
#import "SocialCell.h"
#import "MirchMasala.pch"

@interface SocialView ()
{
    NSMutableArray *SocialArr;
}
@end

@implementation SocialView
@synthesize MainTBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallSocialService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    SocialArr=[[NSMutableArray alloc]initWithObjects:@"Facebook",@"Linkedin",@"Twitter",@"Youtube", nil];
    
    UINib *nib = [UINib nibWithNibName:@"SocialCell" bundle:nil];
    SocialCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [MainTBL registerNib:nib forCellReuseIdentifier:@"SocialCell"];
}
-(void)CallSocialService
{
    [KVNProgress show] ;
    SocialDataArr=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"appButtons" forKey:@"METHOD"];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             SocialDataArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"result"] objectForKey:@"appButtons"] mutableCopy];
             
             CellCount=0;
             for (int ii=0; ii<SocialDataArr.count; ii++)
             {
                  NSString *CheckButtontype=[[SocialDataArr valueForKey:@"button_type"] objectAtIndex:ii];
                 if ([CheckButtontype isEqualToString:@"Social Link"])
                 {
                     CellCount=CellCount+1;
                 }
             }
             
             
             [MainTBL reloadData];
             
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


#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return CellCount;
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
    static NSString *CellIdentifier = @"SocialCell";
    SocialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    NSString *CheckButtontype=[[SocialDataArr valueForKey:@"button_type"] objectAtIndex:indexPath.section];
    if ([CheckButtontype isEqualToString:@"Social Link"])
    {
        cell.SocialTitle_LBL.text=[[SocialDataArr valueForKey:@"title"] objectAtIndex:indexPath.section];
        NSString *Urlstr=[[SocialDataArr valueForKey:@"image_path"] objectAtIndex:indexPath.section];
        [cell.SocialIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [cell.SocialIMG setShowActivityIndicatorView:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
   
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSString *Urlstr=[[SocialDataArr valueForKey:@"content"] objectAtIndex:indexPath.section];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Urlstr]];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
