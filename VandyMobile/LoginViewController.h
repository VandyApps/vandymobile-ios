//
//  LoginViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 6/22/12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UITextField *userInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
