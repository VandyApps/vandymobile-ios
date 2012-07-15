//
//  MyVMViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MyVMViewController : UIViewController

//+ (id)sharedInstance;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
