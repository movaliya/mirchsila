//
//  CheckOut_PaymentVW.m
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "CheckOut_PaymentVW.h"
#import "successMessageVW.h"
#import "cartView.h"
#import "AddCreditCardView.h"

@import Stripe;

@interface CheckOut_PaymentVW ()<STPAddCardViewControllerDelegate,STPPaymentContextDelegate,ExampleViewControllerDelegate>
{
    STPPaymentContext *paymentContext;
}
-(void)submitTokenToBackend:(STPToken *)token;

@property (nonatomic) STPAPIClient *apiClient;
@property (strong, nonatomic) STPPaymentContext *paymentContext;
@end

@implementation CheckOut_PaymentVW
@synthesize CartNotification_LBL,ProcessOrder_Btn,Discount_LBL,OrderAmount_LBL,Collection_CartBTN;
@synthesize Discount,OrderAmount,deliveryCharge;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if (self.Comment3View.length>0)
    {
        NSLog(@"if comment==%@",_Comment3View);
    }
    else
    {
        NSLog(@"else comment==%@",_Comment3View);
    }
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self checkStripKey];
        [self AcceptedOrderTypes];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    OrderType=@"Collection";
    PAYMENTTYPE=@"";
    
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
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    [ProcessOrder_Btn.layer setCornerRadius:20.0f];
    [ProcessOrder_Btn.layer setMasksToBounds:YES];
    
    float disct=[Discount floatValue];
    Discount_LBL.text=[NSString stringWithFormat:@"£%.02f",disct];;
    OrderAmount_LBL.text=[NSString stringWithFormat:@"£%.02f",[OrderAmount floatValue]-disct];
    OrderAmount=[NSString stringWithFormat:@"£%.02f",[OrderAmount floatValue]-disct];
}
-(void)checkStripKey
{
   
    if (![Stripe defaultPublishableKey])
    {
        NSString *PublishableKey = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"PublishableKey"];
        if (!PublishableKey) {
            [self storeDataWithCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * PublishableKey = [[NSUserDefaults standardUserDefaults]
                                                 stringForKey:@"PublishableKey"];
                    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:PublishableKey];
                });
            }];
        }
        else
        {
            [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:PublishableKey];
        }
    }
}
- (void)storeDataWithCompletion:(void (^)(void))completion
{
    // Store Data Processing...
    if (completion) {
        [KmyappDelegate GetPublishableKey];
    }
}
-(void)PlaceOrderServiceCall
{
    [KVNProgress show] ;
    NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
    //NSLog(@"===%@",KmyappDelegate.MainCartArr);
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredient"] mutableCopy];
        NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
        NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
        NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
       
        
       // ProdArr=[[NSMutableArray alloc]init];
        NSString *ProdidSr=[[NSString alloc]init];
        if ([Array isKindOfClass:[NSArray class]])
        {
            //NSLog(@"Array===%@",Array);
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] isEqualToString:@"1"])
                {
                    [Withindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                else
                {
                    [Withoutindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                ProdidSr=[[Array objectAtIndex:i] valueForKey:@"product_id"];
            }
            if (Withindgarr.count>0)
            {
                [inddic setObject:Withindgarr forKey:@"WITHINGREDIENTID"];
            }
            if (Withoutindgarr.count>0)
            {
                [inddic setObject:Withoutindgarr forKey:@"WITHOUTINGREDIENTID"];
            }
        }
        
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"Productid"] forKey:@"ID"];
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"quatity"] forKey:@"QUANTITY"];
        [ProdArr addObject:inddic];
    }
  

    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:CoustmerID forKey:@"CUSTOMERID"];
    [dictInner setObject:OrderType forKey:@"ORDERTYPE"];
    [dictInner setObject:@"0" forKey:@"USEALTERNATEADDRESS"];
    [dictInner setObject:PAYMENTTYPE forKey:@"PAYMENTTYPE"];
    [dictInner setObject:PAIDAMOUNT forKey:@"PAIDAMOUNT"];
    [dictInner setObject:ProdArr forKey:@"PRODUCTS"];
    
    if (self.Comment3View.length>0)
    {
         [dictInner setObject:self.Comment3View forKey:@"COMMENTS"];
    }
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"putitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"webOrder" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSLog(@"dictREQUESTPARAM===%@",dictREQUESTPARAM);
    
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"webOrder"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
            NSString *result=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"webOrder"] objectForKey:@"result"] objectForKey:@"webOrder"];
             NSLog(@"place order result=%@",result);
              //[AppDelegate showErrorMessageWithTitle:@"" message:result delegate:nil];
             
             [KmyappDelegate.MainCartArr removeAllObjects];
             KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
             [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
             KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
             
              successMessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"successMessageVW"];
              [self.navigationController pushViewController:vcr animated:YES];
             //[self.navigationController popToRootViewControllerAnimated:YES];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}
-(void)AcceptedOrderTypes
{
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"getAcceptedOrderTypes" forKey:@"METHOD"];
    
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
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"getAcceptedOrderTypes"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
              NSString *getAcceptedOrderTypes=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"getAcceptedOrderTypes"] objectForKey:@"result"] objectForKey:@"getAcceptedOrderTypes"];
             
              NSLog(@"getAcceptedOrderTypes==%@",getAcceptedOrderTypes);
         }
         
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}
- (IBAction)Radio_Coll_Delvry_Action:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            if([self.Collection_Radio_Btn isSelected]==YES)
            {
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                //[self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
            }
            else{
                OrderType=@"Collection";
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                //[self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
            }
            
            break;
        case 1:
            if([self.Delivery_Radio_Btn isSelected]==YES)
            {
                 [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                //[self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                
            }
            else{
                 OrderType=@"Delivery";
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                //[self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
            }
            break;
            /*
        case 2:
            if([self.Collection_CartBTN isSelected]==YES)
            {
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                //[self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                
            }
            else{
                OrderType=@"Collection & Delivery";
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                //[self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
            }*/
            break;
        default:
            break;
    }
    NSLog(@"OrderType=%@",OrderType);
}

- (IBAction)CreditCard_action:(id)sender
{
    PAIDAMOUNT=OrderAmount;
    PAYMENTTYPE=@"stripe";
    [self.CreditCard_Radio_Brn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
    [self.PayOnCollection_Radio setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
}

- (IBAction)PayOnCollection_action:(id)sender
{
    PAIDAMOUNT=@"0";
    PAYMENTTYPE=@"pay_on_collection";
    [self.CreditCard_Radio_Brn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
    [self.PayOnCollection_Radio setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
}

- (IBAction)ProcessOrder_Action:(id)sender
{
    
    if ([PAYMENTTYPE isEqualToString:@""])
    {
         [AppDelegate showErrorMessageWithTitle:@"" message:@"Please select Payment Type." delegate:nil];
    }
    else if ([OrderType isEqualToString:@"Delivery"])
    {
        if (([deliveryCharge isEqualToString:@"-1"] ||[deliveryCharge isEqualToString:@"-2"])) {
             [AppDelegate showErrorMessageWithTitle:@"Address Problem" message:@"We are not able to calculate Distance from our Restaurant to your Provided Address for some reason. Please check your provided address again." delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self PlaceOrderServiceCall];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
       
    }
    else if ([PAYMENTTYPE isEqualToString:@"stripe"])
    {
         NSLog(@"OrderAmount=%@",OrderAmount);
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            OrderAmount = [OrderAmount stringByReplacingOccurrencesOfString:@"£"
                                                                 withString:@""];
            
            AddCreditCardView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCreditCardView"];
            vcr.delegate = self;
            vcr.amount=[NSDecimalNumber decimalNumberWithString:OrderAmount];
            [self.navigationController pushViewController:vcr animated:YES];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
       
        
        /*
        AddCreditCardView *addCardViewController = [[AddCreditCardView alloc] init];
       addCardViewController.delegate = self;
         addCardViewController.amount=OrderAmount;
        // STPAddCardViewController must be shown inside a UINavigationController.
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
        [self presentViewController:navigationController animated:YES completion:nil];*/
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self PlaceOrderServiceCall];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    
   // successMessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"successMessageVW"];
   // [self.navigationController pushViewController:vcr animated:YES];
}

#pragma mark STPAddCardViewControllerDelegate

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion {
    
    NSLog(@"Token==%@",sourceID);
    if (sourceID)
    {
        completion(STPBackendChargeResultSuccess, nil);
        //[self PlaceOrderServiceCall];
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self ChargeCard:sourceID paidAmount:OrderAmount];
        }
        else
        {
            NSError *error;
             [self exampleViewController:self didFinishWithError:error];
            //[AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
    return;
    
    /*
    if (!kBaseURL) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{NSLocalizedDescriptionKey: @"You must set a backend base URL in Constants.m to create a charge."}];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *urlString = [kBaseURL stringByAppendingPathComponent:@"create_charge"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"source=%@&amount=%@", sourceID, @1099];
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          if (!error && httpResponse.statusCode != 200) {
                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          if (error) {
                                                              completion(STPBackendChargeResultFailure, error);
                                                          } else {
                                                              completion(STPBackendChargeResultSuccess, nil);
                                                          }
                                                      }];
    
    [uploadTask resume];*/
}
-(void)ChargeCard:(NSString *)token paidAmount:(NSString *)Amoumnt
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    
    //This is for Static DummyKey
    //[dict1 setValue:@"DoPUQBErcpKPtRmbjpcFvbb8YCMeBjr4w6OcyjtA" forKey:@"APIKEY"];
    
    //This is for Dynamic APIKEY
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:Amoumnt forKey:@"AMOUNT"];
    
    [dictInner setObject:token forKey:@"TOKEN"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"chargeCard" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    NSLog(@"dictREQUESTPARAM==%@",dictREQUESTPARAM);
    
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
    //NSString *baseurl=@"https://tiffintom.com/api/private/request/data/";
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         NSLog(@"charge card responseObject==%@",responseObject);
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"chargeCard"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             [self PlaceOrderServiceCall];
         }
         else
         {
             [AppDelegate showErrorMessageWithTitle:@"" message:@"Server Error." delegate:nil];
         }
         
         [KVNProgress dismiss] ;
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         //[AppDelegate showErrorMessageWithTitle:@"Payment Failures" message:@"Keep calm and retry!" delegate:nil];
          [self exampleViewController:self didFinishWithError:error];
         [KVNProgress dismiss] ;
     }];

}
#pragma mark - ExampleViewControllerDelegate

- (void)exampleViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
             [self.navigationController popViewControllerAnimated:YES ];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)exampleViewController:(UIViewController *)controller didFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [controller dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}


/*
- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController
               didCreateToken:(STPToken *)token
                   completion:(STPErrorBlock)completion {
    
    NSLog(@"Token=%@",token);
    if (token)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self PlaceOrderServiceCall];
        [AppDelegate showErrorMessageWithTitle:@"Payment Successfully" message:[NSString stringWithFormat:@"%@",token] delegate:nil];
       
    }
    else
    {
         [self dismissViewControllerAnimated:YES completion:nil];
        [AppDelegate showErrorMessageWithTitle:@"Payment Failures" message:@"Keep calm and retry!" delegate:nil];
    }
    
    
}
*/
- (IBAction)TopBarCartBtn_action:(id)sender
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

- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
