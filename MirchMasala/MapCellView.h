//
//  MapCellView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCellView : UIView
{
    
}

@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;



-(void)ReviewCount:(NSString*)stars;

@end
