//
//  RestaurantMenuView.m
//  MirchMasala
//
//  Created by kaushik on 17/03/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "RestaurantMenuView.h"
#import "cartView.h"
#import "CategoriesCell.h"
#import "SubItemView.h"
#import "CategoriesCellWithIMG.h"
#import "MenuListWithImage.h"

@interface RestaurantMenuView ()
{
    NSMutableDictionary *Searchdic;
    BOOL ImageFag;
}
@end

@implementation RestaurantMenuView
@synthesize CartNotification_LBL,MenuTableView;
@synthesize SearchBR;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        NSInteger qnttotal=0;
        for (int i=0; i<KmyappDelegate.MainCartArr.count; i++)
        {
            qnttotal=qnttotal+[[[KmyappDelegate.MainCartArr objectAtIndex:i]valueForKey:@"quatity"] integerValue];
        }
        
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
}

-(void)RegisterCell :(NSString *)CellName
{
    UINib *nib = [UINib nibWithNibName:CellName bundle:nil];
    [MenuTableView registerNib:nib forCellReuseIdentifier:CellName];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SearchBR.hidden=YES;
    SearchBR.layer.borderWidth = 1;
    SearchBR.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

    
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    [self RegisterCell:@"CategoriesCell"];
    [self RegisterCell:@"CategoriesCellWithIMG"];
    
    // Call Category List
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CategoriesList];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
-(void)CategoriesList
{
    
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"topCategories" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         [KVNProgress dismissWithCompletion:^{
             
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 topCategoriesDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"];
                 Searchdic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"];
                 ImageFag=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"containImg"] boolValue];
                 
                 // ImageFag=YES;
                 
                 if (topCategoriesDic)
                 {
                     [MenuTableView reloadData];
                 }
             }

         }];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return topCategoriesDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ImageFag==NO)
    {
        static NSString *CellIdentifier = @"CategoriesCell";
        CategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        cell.TitleLable.text=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CategoriesCellWithIMG";
        CategoriesCellWithIMG *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        cell.TitleLable.text=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SubItemView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubItemView"];
    vcr.CategoryId=[[topCategoriesDic valueForKey:@"id"] objectAtIndex:indexPath.section];
    vcr.categoryName=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ImageFag==NO)
    {
        return 44;
    }
    return 165;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TopBarCartMenu_Action:(id)sender
{
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    if (CoustmerID!=nil)
    {
        cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
        [self.navigationController pushViewController:vcr animated:YES];;
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please First Login"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Login",nil];
        alert.tag=51;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==51)
    {
        if (buttonIndex == 1)
        {
            LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
            [self.navigationController  pushViewController:vcr animated:YES];
        }
    }
}

- (IBAction)Toggle_MenuBrtnAction:(id)sender
{
    [self.rootNav drawerToggle];
    
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}


#pragma mark - SerachBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    SearchBR.hidden=YES;
    
    topCategoriesDic=[Searchdic mutableCopy];
    [SearchBR resignFirstResponder];
    [MenuTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    SearchBR.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [MenuTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    topCategoriesDic=[Searchdic mutableCopy];
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        topCategoriesDic=[Searchdic mutableCopy];
        [MenuTableView reloadData];
        return;
    }
    
    NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in topCategoriesDic)
    {
        NSString *wineName = [wine objectForKey:@"categoryName"];
        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    topCategoriesDic=[resultObjectsArray mutableCopy];
    [MenuTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    topCategoriesDic=[Searchdic mutableCopy];
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
    {
        topCategoriesDic=[Searchdic mutableCopy];
        [MenuTableView reloadData];
        return;
    }
    NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in topCategoriesDic)
    {
        NSString *wineName = [wine objectForKey:@"categoryName"];
        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    topCategoriesDic=[resultObjectsArray mutableCopy];
    [MenuTableView reloadData];
    [SearchBR resignFirstResponder];
}

- (IBAction)Search_Click:(id)sender
{
    SearchBR.hidden=NO;
    SearchBR.text=@"";
    [SearchBR becomeFirstResponder];
}
@end
