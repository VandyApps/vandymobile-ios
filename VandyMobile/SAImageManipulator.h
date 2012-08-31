//
//  SAImageManipulator.h
//
//  Created by Scott Andrus on 8/9/12.
//

#import <Foundation/Foundation.h>

@interface SAImageManipulator : NSObject

+ (UIView *)getPrimaryBackgroundGradientViewForView:(UIView *)view withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot;

+ (UIImage *)screenShotOfView:(UIView *)view;

+ (UIImage *)gradientBackgroundImageForView:(UIView *)view withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot;

+ (void)setGradientBackgroundImageForView:(id)view withTopColor:(UIColor *)gradientTop andBottomColor:(UIColor *)gradientBot;

@end
