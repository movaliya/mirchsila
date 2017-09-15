//
//  MYCartVW.m
//  MirchMasala
//
//  Created by Mango SW on 15/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "MYCartVW.h"
#import "MyCartDownCELL.h"
#import "MyCartUpperCELL.h"
#import "ReservationVW.h"
#import "cartView.h"

@interface MYCartVW ()

@end

@implementation MYCartVW
@synthesize MyTableVW;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellcount=KmyappDelegate.MainCartArr.count;
    
    UINib *nib = [UINib nibWithNibName:@"MyCartUpperCELL" bundle:nil];
    MyCartUpperCELL *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    MyTableVW.rowHeight = cell.frame.size.height;
    [MyTableVW registerNib:nib forCellReuseIdentifier:@"MyCartUpperCELL"];
    
    UINib *nib1 = [UINib nibWithNibName:@"MyCartDownCELL" bundle:nil];
    MyCartDownCELL *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    MyTableVW.rowHeight = cell1.frame.size.height;
    [MyTableVW registerNib:nib1 forCellReuseIdentifier:@"MyCartDownCELL"];
    // Do any additional setup after loading the view.
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cellcount+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == cellcount)
    {
        static NSString *CellIdentifier = @"MyCartDownCELL";
        MyCartDownCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
         [cell.ReservationBTN addTarget:self action:@selector(Reservation_Click:) forControlEvents:UIControlEventTouchUpInside];
         [cell.OrderBTN addTarget:self action:@selector(Order_Click:) forControlEvents:UIControlEventTouchUpInside];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"MyCartUpperCELL";
        MyCartUpperCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section] valueForKey:@"ingredient"] mutableCopy];
        
        float integratPRICE=0.00;
        if ([Array isKindOfClass:[NSArray class]])
        {
            NSString *WithoutStr=[[NSString alloc]init];
            NSString *WithStr=[[NSString alloc]init];
            
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] boolValue]==0)
                {
                    integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price_without"] floatValue];
                    
                    if ([WithoutStr isEqualToString:@""])
                    {
                        WithoutStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                    }
                    else
                    {
                        WithoutStr=[NSString stringWithFormat:@"%@,%@",WithoutStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                    }
                }
                else
                {
                    integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
                    
                    if ([WithStr isEqualToString:@""])
                    {
                        WithStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                    }
                    else
                    {
                        WithStr=[NSString stringWithFormat:@"%@,%@",WithStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                    }
                }
            }
            
            // Without Lable
            if ([WithoutStr isEqualToString:@""])
            {
                cell.Without_LBL.text=@"--";
            }
            else
            {
                cell.Without_LBL.text=WithoutStr;
            }
            
            // With Lable
            if ([WithStr isEqualToString:@""])
            {
                cell.With_LBL.text=@"--";
            }
            else
            {
                cell.With_LBL.text=WithStr;
            }
        }
        else
        {
            cell.Without_LBL.text=@"--";
            cell.With_LBL.text=@"--";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.ProductName_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"productName"];
        
        cell.Quatity_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"quatity"];
        cell.Quatity_LBL.tag=indexPath.section;
        cell.ProductPrice_LBL.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"price"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == cellcount)
    {
        return 111;
    }
    else
    {
        return 80;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)Reservation_Click:(id)sender
{
    ReservationVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationVW"];
    [self.navigationController pushViewController:vcr animated:YES];
    
}
-(void)Order_Click:(id)sender
{
    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)MenuBtn_Click:(id)sender
{
    [self.rootNav drawerToggle];
}
#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
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
