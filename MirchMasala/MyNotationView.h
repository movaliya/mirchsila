//
//  MyNotationView.h
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MapKit.h>

@interface MyNotationView : MKAnnotationView
{
    
}
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic)  NSString *RestNAME_LBL;

@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@end
