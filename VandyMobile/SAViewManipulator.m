//
//  SAViewManipulator.m
//  VandyMobile
//
//  Created by Scott Andrus on 8/20/12.
//
//

#import "SAViewManipulator.h"
#import <QuartzCore/QuartzCore.h>

@implementation SAViewManipulator

+ (void)addShadowToView:(UIView *)view withOpacity:(CGFloat)opacity radius:(CGFloat)radius andOffset:(CGSize)offset {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    if (opacity) {
        if (opacity > 1) opacity = 1;
        else if (opacity < 0) opacity = 0;
        view.layer.shadowOpacity = opacity;
    }
    if (radius) view.layer.shadowRadius = 2.0;
    if (offset.height && offset.width) view.layer.shadowOffset = CGSizeMake(-1, 1);
}

+ (void)addBorderToView:(UIView *)view withWidth:(CGFloat)borderWidth color:(UIColor *)borderColor andRadius:(CGFloat)cornerRadius {
    if (borderWidth) view.layer.borderWidth = borderWidth;
    if (borderColor) view.layer.borderColor = [borderColor CGColor];
    if (cornerRadius) view.layer.cornerRadius = cornerRadius;
}

+ (void)roundNavigationBar:(UINavigationBar *)navigationBar {
    UIView *roundView = [navigationBar.subviews objectAtIndex:0];
    
    CALayer *capa = roundView.layer;
    
    //Round
    CGRect bounds = capa.bounds;
    bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
}

@end
