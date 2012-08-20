//
//  SAViewManipulator.h
//  VandyMobile
//
//  Created by Scott Andrus on 8/20/12.
//
//

#import <Foundation/Foundation.h>

@interface SAViewManipulator : NSObject

+ (void)addShadowToView:(UIView *)view withOpacity:(CGFloat)opacity radius:(CGFloat)radius andOffset:(CGSize)offset;

+ (void)addBorderToView:(UIView *)view withWidth:(CGFloat)borderWidth color:(UIColor *)borderColor andRadius:(CGFloat)cornerRadius;

+ (void)roundNavigationBar:(UINavigationBar *)navigationBar;

@end
