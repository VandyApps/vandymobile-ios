//
//  AppsDetailViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"

@interface AppsDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) App *app;

@end
