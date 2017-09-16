
//
//  LocationView.m
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "LocationView.h"
#import <CoreLocation/CoreLocation.h>
#import "MyNotationView.h"
#import "MapCellView.h"

@interface LocationView ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    MyNotationView *MyAnno;
    NSMutableDictionary *Mapdatadic;
    CLLocation *currentLocation;
    
}
@end

@implementation LocationView
@synthesize MainMap,Direction_BTN,Address_LBL,Contact_LBL,AddressView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallMapService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    AddressView.hidden=YES;
    Direction_BTN.hidden=YES;
    AddressView.layer.cornerRadius=5.0f;
    AddressView.layer.masksToBounds=YES;
    AddressView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    AddressView.layer.borderWidth=0.5f;
    
    Direction_BTN.layer.cornerRadius=25.0f;
    
}

-(void)CallMapService
{
    [KVNProgress show] ;
    Mapdatadic=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:@"DoPUQBErcpKPtRmbjpcFvbb8YCMeBjr4w6OcyjtA" forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"mapAddress" forKey:@"METHOD"];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"mapAddress"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             //dictnory
             Mapdatadic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"mapAddress"] objectForKey:@"result"] mutableCopy];
             AddressView.hidden=NO;
             Direction_BTN.hidden=NO;
             Address_LBL.text=[NSString stringWithFormat:@"Address: %@",[Mapdatadic valueForKey:@"mapAddress"]];
             Contact_LBL.text=[NSString stringWithFormat:@"Contact: %@",[Mapdatadic valueForKey:@"mapContact"]];
             
             if ([Contact_LBL.text containsString:@"(null)"])
             {
                 Contact_LBL.text=[NSString stringWithFormat:@"Contact: "];

             }
             if ([[Mapdatadic valueForKey:@"Latitude"] isEqualToString:@""])
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Locatioln not get" delegate:nil];
             }
             else{
                 [self loadMapPins];
             }
        }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

- (void)loadMapPins
{
    MyAnno=[[MyNotationView alloc] init];
    
    CLLocationCoordinate2D pinlocation;
    pinlocation.latitude =[[Mapdatadic valueForKey:@"Latitude"] floatValue] ;//set latitude of selected coordinate ;
    pinlocation.longitude = [[Mapdatadic valueForKey:@"Longitude"] floatValue]  ;//set longitude of selected coordinate;
    
    // Create Annotation point
    MKPointAnnotation *Pin = [[MKPointAnnotation alloc]init];
    Pin.coordinate = pinlocation;
    Pin.title = [Mapdatadic valueForKey:@"mapAddress"];
    [MainMap addAnnotation:Pin];
    
    [MainMap setRegion:MKCoordinateRegionMakeWithDistance(pinlocation, 600, 600)];

    MyAnno.coordinate=pinlocation;
    MyAnno.RestNAME_LBL=[Mapdatadic valueForKey:@"mapAddress"];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *defaultPinId = @"Pin";
    MyNotationView *pinView = (MyNotationView *)[MainMap dequeueReusableAnnotationViewWithIdentifier:defaultPinId];
    
    if (pinView == nil)
    {
        pinView = [[MyNotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinId];
    }
    pinView.image=[UIImage imageNamed:@"pin"];
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"click");
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        
        MyNotationView *calloutView = (MyNotationView *)[[[NSBundle mainBundle] loadNibNamed:@"myView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
       
        [calloutView.Title_LBL setText:[Mapdatadic valueForKey:@"mapAddress"]];
        
        [view addSubview:calloutView];
        [mapView setCenterCoordinate:[(MyNotationView*)[view annotation] coordinate]];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (UIView *subview in view.subviews)
    {
        [subview removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [MainMap setRegion:[MainMap regionThatFits:region] animated:YES];
//}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
   // [AppDelegate showErrorMessageWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    if (currentLocation != nil)
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];        
        
        NSLog(@"longitude=%.8f",currentLocation.coordinate.longitude);
        NSLog(@"latitude=%.8f",currentLocation.coordinate.latitude);
    }
    [locationManager stopUpdatingLocation];
    locationManager=nil;
}

- (IBAction)Direction_Click:(id)sender
{
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",currentLocation.coordinate.longitude, currentLocation.coordinate.longitude, [[Mapdatadic valueForKey:@"Latitude"] floatValue], [[Mapdatadic valueForKey:@"Longitude"] floatValue]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
}
@end
