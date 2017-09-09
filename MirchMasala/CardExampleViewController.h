//
//  CardExampleViewController.h
//  Stripe iOS Example (Custom)
//
//  Created by Ben Guo on 2/22/17.
//  Copyright © 2017 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExampleViewControllerDelegate;

@interface CardExampleViewController : UIViewController
{
    NSString *amount;
}
@property (nonatomic, weak) id<ExampleViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *amount;

@end
