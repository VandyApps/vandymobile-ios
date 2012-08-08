//
//  UIViewController+Overview.m
//
//  Created by Scott Andrus on 8/1/12.
//

#import "UIViewController+Overview.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Frame.h"

#define kOpacity .8

@implementation UIViewController (Overview)

- (void)presentOverviewController:(UIViewController *)oViewController withOpacity:(CGFloat)opacity animated:(BOOL)animated {
    
    // Set modalTransitionStyles
    oViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // If it's on iPad, set presentation style.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        oViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    // Screenshot of the frame
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        UIGraphicsBeginImageContext(CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height + 20));
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(c, 0, -20);
    } else UIGraphicsBeginImageContext([[UIScreen mainScreen] applicationFrame].size);
    
    [[UIApplication sharedApplication].delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // If it conforms to the Overview Delegate protocol
    // If applicable, set delegate
    if ([oViewController conformsToProtocol:@protocol(OverviewDelegate)] && [oViewController respondsToSelector:@selector(setModalDelegate:)]) {
        [(UIViewController<OverviewDelegate>*)oViewController setModalDelegate:self];
    }
    // SEKRET SAUS
    [self createOverlayOnOverviewController:oViewController withBackgroundImage:viewImage andOpacity:opacity];
    
    // Present the modal view controller
    [self presentModalViewController:oViewController animated:animated];
}

- (void)createOverlayOnOverviewController:(UIViewController *)oViewController withBackgroundImage:(UIImage *)bgImage andOpacity:(CGFloat)opacity {
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        CGRect newFrame = [[UIScreen mainScreen] applicationFrame];
        CGFloat width = newFrame.size.width;
        newFrame.origin.x = 0;
        newFrame.origin.y = 0;
        newFrame.size.width = newFrame.size.height;
        newFrame.size.height = width;
        oViewController.view.frame = newFrame;
    } else oViewController.view.frame = self.view.frame;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
    backgroundImageView.frame = oViewController.view.frame;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:oViewController.view.frame];
    
    if (!opacity) opacity = kOpacity;
    else if (opacity > 1) opacity = 1;
    else if (opacity < 0) opacity = 0;
    
    backgroundView.backgroundColor = [UIColor colorWithRed:0.159 green:0.159 blue:0.159 alpha:opacity]; /*#424242*/
    
    for (UIView *subview in oViewController.view.subviews) {
        [backgroundView addSubview:subview];
    }
    
    [oViewController.view addSubview:backgroundView];
    [oViewController.view addSubview:backgroundImageView];
    
    [oViewController.view sendSubviewToBack:backgroundView];
    [oViewController.view sendSubviewToBack:backgroundImageView];
    
    backgroundImageView.image = bgImage;
    
    [self rotateBackgroundImageView:backgroundImageView ofOViewController:oViewController nintyToOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    backgroundImageView.frame = oViewController.view.frame;
    
    // If it conforms to the Overview Delegate protocol
    if ([oViewController conformsToProtocol:@protocol(OverviewDelegate)] && [oViewController respondsToSelector:@selector(setBGImage:)]) {
        [(UIViewController<OverviewDelegate>*)oViewController setBGImage:backgroundImageView];
    }
    
    [backgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
}

- (void)rotateBackgroundImageView:(UIImageView *)backgroundImageView ofOViewController:(UIViewController *)oViewController nintyToOrientation:(UIInterfaceOrientation)toOrientation {
    float angle;
    
    if (UIInterfaceOrientationIsLandscape(toOrientation)) {
        
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
            angle = M_PI/2;
        } else {
            angle = 3*M_PI/2;  //rotate 270°, or 3π/2 radians
        }
        
        backgroundImageView.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
