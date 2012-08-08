//
//  UIViewController+Overview.h
//
//  Created by Scott Andrus on 8/1/12.
//

/* This class is intended to provide an interface for presenting opaque modal view controllers, dubbed "OverviewControllers". The OverviewDelegate is entirely optional and provides the opportunity to allow delegate setting and custom background image layouts. */

#import <UIKit/UIKit.h>

@protocol OverviewDelegate <NSObject>

@optional

- (void)setModalDelegate:(id)delegate;

- (void)setBGImage:(UIImageView *)backgroundImageView;

@end

@interface UIViewController (Overview)

/* Presents an OverviewController. Works with any view controller, and provides opacity through use of a background image. Rotation is not supported at the moment. iPad is supported.
    If on an iPad, present from the master view controller in landscape.
 
 params:
 opacity: CGFloat value from 0 to 1 determining the alpha value of the background.
 animated: whether to present the view controller with an animation
 */
- (void)presentOverviewController:(UIViewController *)oViewController withOpacity:(CGFloat)opacity animated:(BOOL)animated;

@end
