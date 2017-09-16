//
//  LocationView.h
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MirchMasala.pch"
@interface LocationView : UIViewController
{
    
}
- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *MainMap;

@property (strong, nonatomic) IBOutlet UILabel *Address_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Contact_LBL;
@property (strong, nonatomic) IBOutlet UIView *AddressView;
@property (strong, nonatomic) IBOutlet UIButton *Direction_BTN;
- (IBAction)Direction_Click:(id)sender;
@end
