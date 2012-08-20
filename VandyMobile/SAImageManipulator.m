//
//  SAImageManipulator.m
//
//  Created by Scott Andrus on 8/9/12.
//

#import "SAImageManipulator.h"
#import "OBGradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SAImageManipulator

+ (UIView *)getPrimaryBackgroundGradientViewForView:(UIView *)view withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot {
    
    if (!gradientBot) {
        gradientBot = [UIColor colorWithRed:0.071 green:0.071 blue:0.071 alpha:1] /*#121212*/;
    }
    
    if (!gradientTop) {
        gradientTop = [UIColor colorWithRed:0.231 green:0.231 blue:0.231 alpha:1] /*#3b3b3b*/;
    }
    
	NSArray *gradientColors = [NSArray arrayWithObjects:gradientTop, gradientBot, nil];
	
	OBGradientView *gradientView = [[OBGradientView alloc] init];
	[gradientView setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
	[gradientView setAutoresizingMask:view.autoresizingMask];
	[gradientView setColors:gradientColors];
	
	return gradientView;
}

+ (UIImage *)screenShotOfView:(UIView *)view {
    // Screenshot of the frame
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.layer.frame.size, view.opaque, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    return viewImage;
}

+ (UIImage *)gradientBackgroundImageForView:(UIView *)view withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot {
    return [SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]];
}

+ (CALayer *)getPrimaryBackgroundGradientViewForLayer:(CALayer *)layer withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot {
    
    if (!gradientBot) {
        gradientBot = [UIColor colorWithRed:0.071 green:0.071 blue:0.071 alpha:1] /*#121212*/;
    }
    
    if (!gradientTop) {
        gradientTop = [UIColor colorWithRed:0.231 green:0.231 blue:0.231 alpha:1] /*#3b3b3b*/;
    }
    
	NSArray *gradientColors = [NSArray arrayWithObjects:gradientTop, gradientBot, nil];
	
	OBGradientView *gradientView = [[OBGradientView alloc] init];
	[gradientView setFrame:CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height)];
    UIView *view = [[UIView alloc] initWithFrame:layer.frame];
    [view.layer addSublayer:layer];
	[gradientView setAutoresizingMask:view.autoresizingMask];
	[gradientView setColors:gradientColors];
	
	return gradientView.layer;
}

+ (UIImage *)screenShotOfLayer:(CALayer *)layer {
    // Screenshot of the frame
    UIGraphicsBeginImageContext(layer.frame.size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    return viewImage;
}

+ (UIImage *)gradientBackgroundImageForLayer:(CALayer *)layer withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot {
    return [SAImageManipulator screenShotOfLayer:[SAImageManipulator getPrimaryBackgroundGradientViewForLayer:layer withTopColor:gradientTop andBottomColor:gradientBot]];
}

+ (void)setGradientBackgroundImageForView:(id)view withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot {
    if ([view respondsToSelector:@selector(setBackgroundImage:)]) {
        [view setBackgroundImage:[SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]]];
    } else if ([view respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        [view setBackgroundImage:[SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    } else if ([view respondsToSelector:@selector(setBackgroundImage:forState:barMetrics:)]) {
        [view setBackgroundImage:[SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    } else if ([view respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [view setBackgroundImage:[SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]] forBarMetrics:UIBarMetricsDefault];
    } else if ([view respondsToSelector:@selector(setBackgroundImage:forState:)]) {
        [view setBackgroundImage:[SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]] forState:UIControlStateNormal];
    } else if ([view respondsToSelector:@selector(setImage:forState:)]) {
        [view setImage:[SAImageManipulator screenShotOfView:[SAImageManipulator getPrimaryBackgroundGradientViewForView:view withTopColor:gradientTop andBottomColor:gradientBot]] forState:UIControlStateNormal];
    } else {
        [view insertSubview:[[UIImageView alloc] initWithImage:[SAImageManipulator gradientBackgroundImageForView:view withTopColor:gradientTop andBottomColor:gradientBot]] atIndex:0];
    }
}

@end
