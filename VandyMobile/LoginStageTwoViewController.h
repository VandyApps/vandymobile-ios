//
//  LoginStageTwoViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 7/27/12.
//
//

#import <UIKit/UIKit.h>

@interface LoginStageTwoViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UITextField *userInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
