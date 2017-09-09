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
    return ImageNameSection.count;
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
    
    cell.NewsIMG.image=[UIImage imageNamed:[ImageNameSection objectAtIndex:indexPath.row]];
    
    cell.NewsTitle_LBL.text=@"Good Morning Update";
    cell.Date_LBL.text=@"2017-07-03";    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFullView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsFullView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0f;
}

@end
