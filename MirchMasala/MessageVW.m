//
//  MessageVW.m
//  MirchMasala
//
//  Created by jignesh solanki on 01/02/2018.
//  Copyright © 2018 jkinfoway. All rights reserved.
//

#import "MessageVW.h"
#import "MessageTblCell.h"
@interface MessageVW ()

@end

@implementation MessageVW

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    static NSString *CellIdentifier = @"MessageTblCell";
    UINib *nib = [UINib nibWithNibName:@"MessageTblCell" bundle:nil];
    [_TableVW registerNib:nib forCellReuseIdentifier:CellIdentifier];
    _TableVW.estimatedRowHeight = 220;
    _TableVW.rowHeight = UITableViewAutomaticDimension;
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageTblCell";
    MessageTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    //NSString *Urlstr=[[NewsDataArr valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    //[cell.MessageIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    
    cell.MessageIMG.image=[UIImage imageNamed:@"Icon-App-83.5x83.5@2x.png"];
    
    [cell.MessageIMG setShowActivityIndicatorView:YES];
    
    cell.MessageTitle_LBL.text=@"Silsila Message";
    cell.MessageDetail_LBL.text=@"This is a testing message from silsila app.";
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0f;
}
- (IBAction)Menu_Toggle:(id)sender {
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}
- (void)didReceiveMemoryWarning {
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
